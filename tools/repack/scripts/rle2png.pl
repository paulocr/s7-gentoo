#!/usr/bin/perl

print "\n======================================== \n";
print "Converting initlogo.rle to initlogo.png... Please wait... \n";
print "======================================== \n";

my $dir = "data/initlogo/";
chdir $dir;

open (INITLOGO, "initlogo.rle") or die "Could not open file initlogo.rle: $!\n\n";
close INITLOGO;

print "Converting initlogo.rle to initlogo.raw...\n";
system ("../../bin/from565 < initlogo.rle > initlogo.raw");

print "Converting initlogo.raw to initlogo.png...\n";
system ("convert -depth 8 -size 800x480 rgb:initlogo.raw initlogo.png");

print "Removing initlogo.raw...\n";
system ("rm -f ./initlogo.raw");

print "Removing initlogo.rle...\n";
system ("rm -f ./initlogo.rle");

print "======================================== \n";
print "Converting initlogo.rle to initlogo.png complite!!! \n";
print "========================================\n";