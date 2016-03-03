# Perl: a simple protein domain parser 

[![Build Status](https://travis-ci.org/sillitoe/perl-domain-parser.svg?branch=master)](https://travis-ci.org/sillitoe/perl-domain-parser)

So, we have the following data in a file:

    36e7577f574fa4ff9eeef861a9186178,3.90.70.10.FF16963,57:453,1,VSTDSTPV...
    5249a5fc81889aa16399bda7cb51b719,3.30.930.10.FF32055,10:258,1,TATNVRNT...

Where the columns are:

    Protein MD5, Superfamily, Segments, ...

What we know about the data:

 * Each row represents a protein domain which can have one or more segments.
 * Each protein (md5) can have one or more domain

This project is an example of how you might go about parsing this data into sensible objects using Perl and Moose. This is more about introducing new people to Perl within our lab, rather than providing production code (probably want to look at BioPerl if you're interested in the latter).

