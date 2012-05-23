#!/usr/bin/perl

print "\n======================================== \n";
print "Converting splash.raw565 to splash.png... Please wait... \n";
print "======================================== \n";

my $dir = "data/splash/";
chdir $dir;

open (SPLASH, "splash.raw565") or die "Could not open file splash.raw565: $!\n\n";
close SPLASH;

print "Converting splash.raw565 to splash.raw...\n";
system ("../../bin/from565 < splash.raw565 > splash.raw");

print "Converting splash.raw to splash.png...\n";
system ("convert -depth 8 -size 800x480 rgb:splash.raw splash.png");

print "Removing splash.raw...\n";
system ("rm -f ./splash.raw");

print "Removing splash.raw565...\n";
system ("rm -f ./splash.raw565");

print "======================================== \n";
print "Converting splash.raw565 to splash.png complite!!! \n";
print "========================================\n";