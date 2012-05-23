#!/usr/bin/perl
######################################################################
#
#   File          : split_updata.pl
#   Author(s)     : McSpoon
#   Description   : Unpack a Huawei U8220 'UPDATA.APP' file.
#                   http://pulse.modaco.com
#
#   Last Modified : Thu 24 December 2009
#   By            : McSpoon
#
#   Last Modified : Wed 18 June 2010
#   By            : ZeBadger (z e b a d g e r @ h o t m a i l . c o m)
#   Comment       : Added filename selection
#
#   Last Modified : Wed 19 June 2010
#   By            : ZeBadger (z e b a d g e r @ h o t m a i l . c o m)
#   Comment       : Added CRC checking
#
######################################################################
 
use strict;
use warnings;

print "\n======================================== \n";
print "Extract UPDATA.APP... Please wait... \n";
print "======================================== \n";

my %fileHash=(	"\x00\x00\x00\x10","appsboot.mbn",
		"\x00\x00\x00\x20","file25.mbn",
		"\x00\x00\x00\x30","boot.img",
		"\x00\x00\x00\x40","system.img",
		"\x00\x00\x00\x50","userdata.img",
		"\x00\x00\x00\x60","recovery.img",
		"\x00\x00\x00\xC0","file11.mbn",
		"\x00\x00\x00\xD0","file08.mbn",
		"\x00\x00\x00\xE0","file05.mbn",
		"\x00\x00\x00\xF0","file04.mbn",
		"\x00\x00\x00\xF1","file07.mbn",
		"\x00\x00\x00\xF2","splash.raw565",
		"\x00\x00\x00\xF3","file01.mbn",
		"\x00\x00\x00\xF4","file02.mbn",
		"\x00\x00\x00\xF5","file14.mbn",
		"\x00\x00\x00\xF6","boot_versions.txt",
		"\x00\x00\x00\xF7","upgradable_versions.txt",
		"\x00\x00\x00\xF8","file09.mbn",
		"\x00\x00\x00\xF9","version.txt",
		"\x00\x00\x00\xFA","file20.mbn",
		"\x00\x00\x00\xFB","appsboothd.mbn",
		"\x00\x00\x00\xFC","file23.mbn",
		"\x00\x00\x00\xFD","file16.mbn",
		"\x00\x00\x00\xFE","file18.mbn",
		"\x00\x00\x00\xFF","file21.mbn",
	);

my $unknown_count=0;

$|++;

use constant UINT_SIZE => 4;

my $FILENAME = undef;
if ($#ARGV == -1) {
	$FILENAME = "data/updata/UPDATA.APP";
} else {
	$FILENAME = $ARGV[0];
}

open(INFILE, $FILENAME) or die "Cannot open $FILENAME: $!\n\n";
binmode INFILE;
 
# Skip the first 92 bytes, they're blank.
#seek(INFILE, 92, 0);
 
my $fileLoc=0;
my $BASEPATH = "data/updata/";
mkdir $BASEPATH;

while (!eof(INFILE)) {
	$fileLoc=&find_next_file($fileLoc);
	seek(INFILE, $fileLoc, 0);
	$fileLoc=&dump_file();
}

close INFILE;

sub find_next_file {
	my ($_fileLoc) = @_;
	my $_buffer = undef;
	my $_skipped=0;
	read(INFILE, $_buffer, UINT_SIZE);
	while ($_buffer ne "\x55\xAA\x5A\xA5" && !eof(INFILE)) {
		read(INFILE, $_buffer, UINT_SIZE);
		$_skipped+=UINT_SIZE;
	}
	return($_fileLoc + $_skipped);
}
 
sub dump_file {
    my $buffer = undef;
    my $outfilename = undef;
    my $fileSeq;
    my $calculatedcrc = undef;
    my $sourcecrc = undef;
    my $fileChecksum;
    read(INFILE, $buffer, UINT_SIZE);
    unless ($buffer eq "\x55\xAA\x5A\xA5") { die "Unrecognised file format. Wrong identifier.\n"; }
    read(INFILE, $buffer, UINT_SIZE);
    my ($headerLength) = unpack("V", $buffer);
    read(INFILE, $buffer, 4);
    read(INFILE, $buffer, 8);
    read(INFILE, $fileSeq, 4);
    if (exists($fileHash{$fileSeq})) {
		$outfilename=$fileHash{$fileSeq};
    } else {
		$outfilename="unknown_file.$unknown_count";
		$unknown_count++;
    }
    read(INFILE, $buffer, UINT_SIZE);
    my ($dataLength) = unpack("V", $buffer);
    read(INFILE, $buffer, 16);
    read(INFILE, $buffer, 16);
    read(INFILE, $buffer, 16);
    read(INFILE, $buffer, 16);
    read(INFILE, $buffer, 2);
    read(INFILE, $buffer, 2);
    read(INFILE, $buffer, 2);
    read(INFILE, $fileChecksum, $headerLength-98);
    $sourcecrc=slimhexdump($fileChecksum);
    read(INFILE, $buffer, $dataLength);
    open(OUTFILE, ">$BASEPATH$outfilename") or die "Unable to create $outfilename: $!\n";
    binmode OUTFILE;
    print OUTFILE $buffer;
    close OUTFILE;
    $calculatedcrc=`bin/crc $BASEPATH$outfilename`;
    chomp($calculatedcrc);
    print STDOUT "Extracted $outfilename";
    if ($calculatedcrc eq $sourcecrc) {
		print " - CRC Okay\n";
	} else {
		print " - ERROR: CRC did not match\n";
	}
    my $remainder = UINT_SIZE - (tell(INFILE) % UINT_SIZE);
    if ($remainder < UINT_SIZE) {
    	read(INFILE, $buffer, $remainder);
    }
    return (tell(INFILE));
}

sub hexdump () {
	my $num=0;
	my $i;
	my $rhs;
	my $lhs;
	my ($buf) = @_;
	my $ret_str="";
	foreach $i ($buf =~ m/./gs) {
		$lhs .= sprintf(" %02X",ord($i));
		if ($i =~ m/[ -~]/) {
			$rhs .= $i;
		} else {
			$rhs .= ".";
		}
		$num++;
		if (($num % 16) == 0) {
			$ret_str.=sprintf("%-50s %s\n",$lhs,$rhs);
			$lhs="";
			$rhs="";
		}
	}
	if (($num % 16) != 0) {
		$ret_str.=sprintf("%-50s %s\n",$lhs,$rhs);
	}
	return ($ret_str);
}

sub slimhexdump () {
	my $i;
	my ($buf) = @_;
	my $ret_str="";
	foreach $i ($buf =~ m/./gs) {
		$ret_str .= sprintf("%02X",ord($i));
	}
	return ($ret_str);
}

print "Removing UPDATA.APP file...\n";
system ("rm data/updata/UPDATA.APP");
print "======================================== \n";
print "Extract UPDATA.APP complite!!! \n";
print "========================================\n";