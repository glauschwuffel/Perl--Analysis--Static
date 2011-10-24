#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('PSA::Document');
    use_ok('PSA::Element::Sub');
    use_ok('PSA::Analysis::Sub');
}

my $filename='t/data/subs.pl';
my $document = PSA::Document->new(filename => $filename);

my $expected = [
    PSA::Element::Sub->new( name => 'function', from => 1, to => 3 ),
    PSA::Element::Sub->new( name => 'method', from => 5, to => 7 ),
];

my $analysis=PSA::Analysis::Sub->new();
my $got = $analysis->analyse($document);

is_deeply( $got, $expected );

# use Data::Dumper;print Dumper($got);
