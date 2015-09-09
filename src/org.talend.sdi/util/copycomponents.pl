#!/usr/bin/perl -w

use strict;

use File::Copy;
use File::Basename;
use File::Path;

my $tos = shift;

sub copyDir {
    my $src = shift;
    my $dst = shift;
    my ($dir, undef, undef) = fileparse($src, qr/\.[^.]*/);
    if (! -d "$dst/$dir") {
        &File::Path::mkpath("$dst/$dir") or die "mkdir failed: $!";
    }
    opendir DIR, "$src" or die "opendir failed: $!";
    my @content = readdir DIR;
    close DIR;
    for my $entry (@content) {
        next if ($entry eq ".");
        next if ($entry eq "..");
        next if ($entry eq ".svn");
        if (-d "$src/$entry") {
            copyDir("$src/$entry", "$dst/$dir");
        } else {
            copy("$src/$entry", "$dst/$dir/$entry") or return 0;
        }
    }
    return 1;
}

copyDir(".spatial", "$tos/workspace/.spatial");

my @content;

opendir DIR, "$tos/plugins";
@content = readdir DIR;
close DIR;

my $compdir = undef;
for my $subdir (@content) {
    if ($subdir =~ m/^org\.talend\.designer\.components/ && -d "$tos/plugins/$subdir") {
        $compdir = $subdir;
        last;
    }
}
$compdir = "$tos/plugins/$compdir/components";

opendir DIR, "." or die "opendir failed: $!";
@content = readdir DIR;
close DIR;

for my $comp (@content) {
    next if ($comp !~ m/^s/);
    next if ($comp eq "src");
    copyDir("$comp", "$compdir");
}

exit 0;
