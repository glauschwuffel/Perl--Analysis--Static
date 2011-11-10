#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Differences;

BEGIN {
    use_ok('Perl::Analysis::Static::Files');
}

my $dir='t/data';
my @got = sort {$a cmp $b} @{Perl::Analysis::Static::Files::files($dir)};

my @expected = qw(
t/data/lexicals_and_blocks.pl
t/data/locals_and_blocks.pl
t/data/package_variables.pl
t/data/strings.pl
t/data/subs.pl
t/data/uses.pl
);

eq_or_diff( \@got, \@expected );

