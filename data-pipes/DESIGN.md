The 3 sample files sent have identical enough data to form a parser that can handle the variances.  If the other ingestion sources will contain similar data then it we will get value out of creating reusable identifiers.  


### Ruby

I've used Ruby because of a few reasons:

* it is a very expressive language, can be written in many styles based on what language someone typically thinks-in, and has very smooth FP expression that later parallelize well.
* it's a common binary on most VMs
* If it happens to stick around - Ruby 3 will have a native option static typing, Crystal already does, and Elixir/Phoenix make strongly functional evented systems.

### scrape / process
https://github.com/igrigorik/bloomfilter-rb

### Parse
https://github.com/pocari/regexp-ruby

### formatting
* https://github.com/PeterCamilleri/format_engine

