#!/usr/bin/perl

print "\n======================================== \n";
print "Flashing $ARGV[1]... Please wait... \n";
print "======================================== \n";

my $part = "";
if ($ARGV[0] =~ /splash/) {
	$part = "logo";
} else {
	$part = $ARGV[0];
}

open (IMAGE, "data/$ARGV[0]/$ARGV[1]") or die "Could not open $ARGV[1]: $!\n\n";
close IMAGE;
system ("bin/fastboot flash $part data/$ARGV[0]/$ARGV[1]");

print "======================================== \n";
print "Flashing $ARGV[1] complite!!! \n";
print "======================================== \n";