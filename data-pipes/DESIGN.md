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

### Scrape / process

Scaling and managing the ingest is best done by eventing most of the process.  Files are probably retrieved via SFTP or similar bulk process.  The healthcare network already uses a cloud, we can host services in the same cloud for the speed / data gravity principle.  Scraping / crawling is [a studied area in ACM and related CS literature](https://dl.acm.org/results.cfm?query=crawler), when we think we can benefit from the cutting-edge. If we find that sourcing the data has a graph component, the common pattern in FOSS tooling is [a bloom filter](https://github.com/igrigorik/bloomfilter-rb) for the worker target cache.

In this take-home, I don't think there's need to build a scraping orchestrator.

### Parse

The core of the parsing is going to be 

* searching for identities / features
* parsing them in a way that allows reprocessing

If structure of our source is complex (nested and dependently-linked) enough, then we will need to plan a parser design that accounts for deterministic vs non-deterministic finite automatons. (DFA/NFA)

https://github.com/pocari/regexp-ruby

### Output Formatting
* https://github.com/PeterCamilleri/format_engine

