# 99 Problems and NP Aint an Element of the Subsets

While the trivial recursive solution to the problem would be easy to iterate over, efficiently solutions at scale will involve some more complex handling. 

### Context

In the interest of a fair self-evaluation, I have avoided reading any literature on the topic, including the XKCD forums, as they're surely rife with answers.  I have re-read the header of the wikipedia article, to ensure that I didn't forget anything foundational from my CS coursework.

### Demonstration Breadth

Since this exercise is principally one to demonstrate code thinking, it's reasonable to write several solutions, and include a profiling module for benchmarking the execution.

I've also not decided to search for all solutions, vs whatever is the first hit.  

The most trivial answer will be when any menu item is an even denominator do the total target spent.  Since this requires no recursion or cache/branch solutions, I think it's reasonable to have a minimal check for such, before searching for a 'variety' solution. 

So this leaves us with:

#### Problem Cases

*Each in need of an algorithm*

* trivial cases
* basic recursion
* cache solutions
* branching solutions

#### Sidecars

* time benchmarking
* input generator
  * input constraints
* tests