#!/usr/bin/perl

print "\n======================================== \n";
print "Converting initlogo.png to initlogo.rle... Please wait... \n";
print "======================================== \n";

my $dir = "data/initlogo/";
chdir $dir;

open (INITLOGO, "initlogo.png") or die "Could not open file initlogo.png: $!\n\n";
close INITLOGO;

print "Converting initlogo.png to initlogo.raw...\n";
system ("convert -resize 800x480! -depth 8 initlogo.png rgb:initlogo.raw > /dev/null");

print "Converting initlogo.raw to initlogo.rle...\n";
system ("../../bin/to565 < initlogo.raw > initlogo.rle");

print "Removing initlogo.png...\n";
system ("rm -f ./initlogo.png");

print "Removing initlogo.raw...\n";
system ("rm -f ./initlogo.raw");

print "======================================== \n";
print "Converting initlogo.png to initlogo.rle complite!!! \n";
print "========================================\n";