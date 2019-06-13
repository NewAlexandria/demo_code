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

In this take-home, I don't think there's need to build a scraping orchestrator.

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



### Output Formatting

There are a number of reasons to [separate output formatting from data storage](https://github.com/PeterCamilleri/format_engine), in a system like this.  The practice commonly happens with web content publication, because the consumer of web content can be humans with different reader formats, accessibility needs, or bots that consume for republishing, sharing, or search/crawling.

Separating output formatting / rendering / presenters ensures that the data warehouse remains a consistent source of truth, while allowing for many different consumers of the data platform.



