#!/usr/bin/perl

print "\n======================================== \n";
print "Converting splash.png to splash.raw565... Please wait... \n";
print "======================================== \n";

my $dir = "data/splash/";
chdir $dir;

open (SPLASH, "splash.png") or die "Could not open file splash.png: $!\n\n";
close SPLASH;

print "Converting splash.png to splash.raw...\n";
system ("convert -depth 8 splash.png rgb:splash.raw");

print "Converting splash.raw to splash.raw565...\n";
system ("../../bin/to565 < splash.raw > splash.raw565");

print "Removing splash.png...\n";
system ("rm -f ./splash.png");

print "Removing splash.raw...\n";
system ("rm -f ./splash.raw");

print "======================================== \n";
print "Converting splash.png to splash.raw565 complite!!! \n";
print "========================================\n";