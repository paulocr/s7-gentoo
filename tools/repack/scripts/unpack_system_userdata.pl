#!/usr/bin/perl

die "Did not specify img file\n" unless $ARGV[0];

print "\n======================================== \n";
print "Extract $ARGV[0]... Please wait... \n";
print "======================================== \n";

my $dir = "";

if ($ARGV[1] == 0) {
	$dir = "data/system/";
} else {
	$dir = "data/userdata/";
}

chdir $dir;

open (IMGFILE, "$ARGV[0]") or die "Could not open img file $dir$ARGV[0]: $!\n\n";
close IMGFILE;

system ("../../bin/unyaffs $ARGV[0]");

print "Removing $ARGV[0]... \n";
system ("rm $ARGV[0]");

print "======================================== \n";
print "Extract $ARGV[0] complite!!! \n";
print "========================================\n";