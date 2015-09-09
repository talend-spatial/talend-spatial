#!/usr/bin/perl -w

use strict;

use File::Copy;

sub copyJars {
    my $comp = shift;
    print "./components/$comp/${comp}_java.xml";
    open F, "< ./components/$comp/${comp}_java.xml" or die "open failed: $!";
    while (<F>) {
        next if ($_ !~ m/MODULE=\".+\.jar\"/);
        my ($jar) = ($_ =~ m/MODULE=\"(.+\.jar)\"/);
        if ($comp eq "sGeoInput" or ! -f "./components/sGeoInput/$jar") {
            if (-f "./lib/$jar") {
                copy("./lib/$jar", "./components/$comp/$jar") or die "copy failed: $!";
            } elsif ($comp eq "sGeoInput") {
                die "./lib/$jar does not exist!";
            }
        }
    }
    close F;
}

print "copying sGeoInput jars...\n";
copyJars("sGeoInput");

opendir DIR, "./components" or die "opendir failed: $!";
my @content = readdir DIR;
close DIR;

for my $comp (@content) {
    next if ($comp !~ m/^s/);
    next if ($comp eq "src");
    next if ($comp eq "sGeoInput");
    next if ($comp eq "sGeoLoc");
    print "copying $comp jars...\n";
    copyJars($comp);
}

exit 0;
