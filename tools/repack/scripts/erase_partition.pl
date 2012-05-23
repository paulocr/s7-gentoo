#!/usr/bin/perl

print "\n======================================== \n";
print "Erasing $ARGV[0]... Please wait... \n";
print "======================================== \n";

system ("bin/fastboot erase $ARGV[0]");

print "======================================== \n";
print "Erasing $ARGV[0] complite!!! \n";
print "======================================== \n";