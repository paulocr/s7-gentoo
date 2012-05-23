#!/usr/bin/perl -W

print "\n======================================== \n";
print "Repack $ARGV[0]... Please wait... \n";
print "======================================== \n";

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

chdir "data/";

print "Creation $ARGV[0].img...\n";
system ("../bin/mkyaffs2image $ARGV[0] $ARGV[0].img");

print "Removed temp files...\n";
my ( $size, @files ) = filesList( "$ARGV[0]", "1" );
mkdir "$ARGV[0]" or die;
system ("cp $ARGV[0].img $ARGV[0]/$ARGV[0].img");
system ("rm $ARGV[0].img");

print "======================================== \n";
print "Repack $ARGV[0].img complite!!! \n";
print "========================================\n";