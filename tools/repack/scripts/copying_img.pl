#!/usr/bin/perl

print "\n======================================== \n";
print "Copying *.img from updata folder... Please wait... \n";
print "======================================== \n";


print "Check file boot.img...\n";
open (BOOT, "data/updata/boot.img") or die "Could not open img file boot.img: $!\n\n";
close BOOT;

print "Check file recovery.img...\n";
open (RECOVERY, "data/updata/recovery.img") or die "Could not open img file recovery.img: $!\n\n";
close RECOVERY;

print "Check file system.img...\n";
open (SYSTEM, "data/updata/system.img") or die "Could not open img file system.img: $!\n\n";
close SYSTEM;

print "Check file userdata.img...\n";
open (USERDATA, "data/updata/userdata.img") or die "Could not open img file userdata.img: $!\n\n";
close USERDATA;

print "Copying boot.img...\n";
system ("cp data/updata/boot.img data/boot/boot.img");
print "Copying recovery.img...\n";
system ("cp data/updata/recovery.img data/recovery/recovery.img");
print "Copying system.img...\n";
system ("cp data/updata/system.img data/system/system.img");
print "Copying userdata.img...\n";
system ("cp data/updata/userdata.img data/userdata/userdata.img");

print "======================================== \n";
print "Copying *.img from updata folder complite!!! \n";
print "========================================\n";