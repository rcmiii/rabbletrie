rabbletrie
==========

Scrabble word finder in Ruby, using a trie structure.

Inspired by this answer on SO: http://stackoverflow.com/a/7419003

-USAGE-
ruby scrabble.rb "ABCDXYZ"

-NOTES-
--Wildcards can be inserted with the "*" character, like 

ruby scrabble.rb "ABC*XYZ"

 Currently the application won't take them into account when scoring, though. Make sure to use quotes around your string if you're using a wildcard.

--The first time the app is run, it will have to create the whole trie data structure, so it may take a few seconds. 