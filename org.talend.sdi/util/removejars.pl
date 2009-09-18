#!/usr/bin/perl -w

use strict;

sub remJars {
    my $comp = shift;
    opendir DIR, "./components/$comp" or die "opendir failed: $!";
    my @content = readdir DIR;
    close DIR;
    for my $file (@content) {
        next if ($file !~ m/.+\.jar$/);
        next if (! -f "./lib/$file");
	print "Removing ./components/$comp/$file\n";
	unlink "./components/$comp/$file" or die "unlink failed: $!";
    }
}

print "Removing JAR from components dir ...";
opendir DIR, "./components" or die "opendir failed: $!";
my @content = readdir DIR;
close DIR;

for my $comp (@content) {
    next if ($comp !~ m/^s/);
    next if ($comp eq "src");
    remJars($comp);
}

exit 0;
