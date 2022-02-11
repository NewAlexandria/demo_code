# Running

Make sure you have ruby installed.  Ideally ruby >= 2.5.x

On a mac

```
brew install rbenv ruby-build
rbenv install 2.5.3
```

then run

```
ruby runner.rb
```


# Design

The 3 sample files sent have identical enough data to form a parser that can handle the variances.  If the other ingestion sources will contain similar data then it we will get value out of creating reusable identifiers.  


### Ruby

I've used Ruby because of a few reasons:

* it is a very expressive language, can be written in many styles based on what language someone typically thinks-in, and has very smooth FP expression that later parallelize well.
* it's a common binary on most VMs
* If it happens to stick around - Ruby 3 will have a native option static typing, Crystal already does, and Elixir/Phoenix make strongly functional evented systems.

## Architectural Design

I assume that backing behind the ETL/ELT portion needs to scale in a way that allows for 

1. re-runs and re-extraction.
1. a minimum of re-crunching.
1. a balance of metadata to maximization research opportunities.

As a bonus, it would be good to contextualize the read so that we minimize the effort for a future innovation to write back to healthcare system in its native record format.

### Scrape / Process

Scaling and managing the ingest is best done by eventing most of the process.  Files are probably retrieved via SFTP or similar bulk process.  The healthcare network already uses a cloud, we can host services in the same cloud for the speed / data gravity principle.  Scraping / crawling is [a studied area in ACM and related CS literature](https://dl.acm.org/results.cfm?query=crawler), when we think we can benefit from the cutting-edge. If we find that sourcing the data has a graph component, the common pattern in FOSS tooling is [a bloom filter](https://github.com/igrigorik/bloomfilter-rb) for the worker target cache.

In this take-home, it doesn't look like there is a need to build a scraping orchestrator.

### Parse

#### Design

The core of the parsing is going to be 

* searching for identities / features
* parsing them in a way that allows reprocessing

If structure of our source is complex (nested and dependently-linked) enough, then we will need to plan a parser design that accounts for deterministic vs non-deterministic finite automatons. (DFA/NFA). If the link-dependency os low enough, and we can afford the storage + run time, then we can make a DFA problem out of any NFA problem. 

In reality, I don't see any of that need, from the sample data. 

Parse with

* source-location 
* position/context in the source
* parser version/ID
* parse date

These three vectors will allow us to monitor for when to reprocess based on changes to the source / file, and whether to re-parse based on parser/identity changes.  

Storing the position of the original data is a small price to pay for targeted re-extraction, and the option to later analyze relative positions as meaningful metadata.

We will typically extract a feature's

* type
* value
* unit-kind

Recording standard unit values makes it easier, later, to compare, group, and enable predicate logic searches for a unit's role in a complex equation, relationship, or expression.

#### Strategy

1. parse data groups.
  * retain linkage
2. parse common identities in each group.
  * non-identities should have generic types.
  * retain linkage
3. parse [field data](https://github.com/pocari/regexp-ruby) from each identity.
  * retain linkage
4. fold all back into an output format based on linkages

This demo implementation assumes files that can be read into memory.  

The type/identity recognition, here, will be a static list based on what's evident in the file.  This would be the basis of a reinforcement-learning system for recognizing identities. 

Every un-identified entity/quantity would be left unlabeled until manual intervention and labeling by an SME. Those labels would be used to train an classifier that makes UI suggestions to SMEs in the future, until there is enough reinforcement to auto-label.

The demo code here will make some hard-coded assumptions about the meaning of position, in labeling certain data fields.  The can scale to a true discovery-oriented ML system, by including position as one of the dimensions of a neural net.  Position / field-length encoding has a classic role in ETL as well. 

The system would eventually look to identify a label by

* fuzzy labeling
* value
* field position

or a mixture of them.  

In some places I elected to filter certain actions within a loop.  In a production environment with high-volume data, we would split lists and recombine them, to minimize reprocessing. 

In the interest of time, I have not use OOO to de-duplicate some code and functions.  Likewise, SRP is not always followed.

### Output Formatting

There are a number of reasons to [separate output formatting from data storage](https://github.com/PeterCamilleri/format_engine), in a system like this.  The practice commonly happens with web content publication, because the consumer of web content can be humans with different reader formats, accessibility needs, or bots that consume for republishing, sharing, or search/crawling.

Separating output formatting / rendering / presenters ensures that the data warehouse remains a consistent source of truth, while allowing for many different consumers of the data platform.

The demo does not do this.

