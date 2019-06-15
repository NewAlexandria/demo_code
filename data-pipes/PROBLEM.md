# The Problem

A technical evaluation based on the real-world needs of -PN-.


### High level requirements for the -PN- backend service:

* Accept, transform, and store electronic healthcare records from multiple providers into a single data-store
* These records will come in a variety of formats about a variety of medical test/topics.
* Your customers are researchers around the world who will want to be able to search, discover, retrieve, and perform analysis
* Ideally all analysis will be performed within the -PN- systems, allowing us to maintain control over data at all times


### We're imagining that this will look something like

* A way to ingest, transform, and clean files from multiple health care providers
* A place to store all the cleaned data
* A platform to allow researchers to query and retrieve data
* A web-based capability that allows researchers to perform analysis of the data in our platform.

For this technical interview we're going to ask you to come up with a proposed high-level architecture for this project and implement a small piece of it. 

## The Take Home Part:

One of the most critical parts of this application is getting data into our data-store.  Given that health care data is in numerous different formats and often not easily readable by computers, we’ll have to build out a pipeline that can read in this data, clean it, and store it into some more-consistent format.  We will have a team to work with you on this in your engineering director role, but here we want you to write a sample script for how to do this on one particular file format. 

* Included are several attached mock data files representing ECG results from a health care provider.
* Write a program that can take in these files and "clean" them. 
* Your program should output whatever data you would propose storing in your primary data-store that we would then build tools on top of.
* You can use any language, frameworks, or packages you'd like. Please include instructions on how to run your script. 



## The Phone-Call Part

We'll talk through your data processing script and ask questions about design decisions and how you would handle other data formats in a similar fashion.  We will also talk through how you would imagine designing the larger architecture of this project, including:

* Specific technologies
* What you would build vs buy.
* Challenges you see
* Resources needed (people, money, etc)
* Timelines
* Open questions you would need answered to get started.