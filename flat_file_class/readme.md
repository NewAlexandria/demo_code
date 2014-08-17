# A Demo Project

This code assembles a single set of records by parsing data from 3 different file formats and then display these records sorted in 3 different ways.

A record consists of the following 5 fields: last name, first name, gender, date of birth and favorite color. 

A rake file handles the output of the records:

* Output 1 – sorted by gender (females before males) then by last name ascending.
* Output 2 – sorted by birth date, ascending.
* Output 3 – sorted by last name, descending.

Run `rake report:export_all` in this directory

Ruby version `2.0.0-p195` is defined in the `.ruby-version` file.

