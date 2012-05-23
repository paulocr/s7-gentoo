#!/usr/bin/perl -W

use strict;
use Cwd;

my $dir = getcwd;
my $usage = "repack-bootimg.pl <kernel> <ramdisk-directory> <outfile>\n";
die $usage unless $ARGV[0] && $ARGV[1] && $ARGV[2];

sub filesList {
	my $start_dir = $_[ 0 ];
	my ( $number, $size ) = ( 0, 0 );
	my ( @directories, @files, @dir );
	return if !$start_dir or !-d $start_dir;
	$directories[ 0 ] = $start_dir;

	for ( my $i = 0; $i <= $number; $i++ ) {
		opendir( local *DIR, $directories[ $i ] );
		@dir = readdir( DIR );
		closedir( DIR );
		for ( my $k = 0; $k <= $#dir; $k++ ) {
			if ( $i == 0 ) { 
				local $/ = '/'; chomp $directories[ 0 ];
			}
			if ( -d "$directories[ $i ]/$dir[ $k ]" and $dir[ $k ] ne '.' and $dir[ $k ] ne '..' ) {
				$directories[ ++$number ] = "$directories[ $i ]/$dir[ $k ]";
			}
		}
	}

	$directories[ 0 ] = $start_dir;
	@directories = sort( @directories );
	for ( my $i = 0; $i <= $number; $i++ ) {
		opendir( local *DIR, $directories[ $i ] );
		@dir = readdir( DIR );
		closedir( DIR );
		for ( my $k = 0; $k <= $#dir; $k++ ) {
			if ( $i == 0 ) { 
				local $/ = '/'; chomp $directories[ 0 ]; 
			}
			if ( !-d "$directories[ $i ]/$dir[ $k ]" ) {
				$size += ( stat( "$directories[ $i ]/$dir[ $k ]" ) )[ 7 ];
				push( @files, "$directories[ $i ]/$dir[ $k ]" )
			}
		}
	}

	if ( $_[ 1 ] ) {
		unlink( @files );
		for ( my $i = $#directories; $i >= 0; $i-- ) { rmdir $directories[ $i ] }
	}
	return $size, @files;
}

print "\n======================================== \n";
print "Repack $ARGV[2]... Please wait... \n";
print "======================================== \n";

my $workdir = "";

if ($ARGV[3] == 0) {
	$workdir = "data/boot/";
} else {
	$workdir = "data/recovery/";
}

chdir $workdir;
chdir $ARGV[1] or die "$ARGV[1] $!";
print "Creation ramdisk-repack.cpio.gz...\n";
system ("find . | cpio -o -H newc | gzip > $dir/$workdir/ramdisk-repack.cpio.gz");
chdir "$dir/$workdir" or die "$ARGV[1] $!";
print "Creation $ARGV[2]...\n";
system ("../../bin/mkbootimg --cmdline 'console=ttyMSM2,115200n8 androidboot.hardware=qsd8k_s7' --base 0x20000000 --kernel $ARGV[0] --ramdisk ramdisk-repack.cpio.gz -o $ARGV[2]");
unlink("ramdisk-repack.cpio.gz") or die $!;
print "Removed directory $ARGV[1]\n";
my ( $size, @files ) = filesList( "$ARGV[1]", "1" );
print "Removed *.gz files\n";
system ("rm *.gz");

print "Removed zImage\n";
system ("rm zImage");

print "======================================== \n";
print "Repack $ARGV[2] complite!!! \n";
print "======================================== \n";