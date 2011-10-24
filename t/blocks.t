#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('PSA::Document');
    use_ok('PSA::Element::Block');
    use_ok('PSA::Analysis::Block');
}

my $filename='t/data/lexicals_and_blocks.pl';
my $document = PSA::Document->new(filename => $filename);

my $expected = [
    PSA::Element::Block->new( from=>2, to=>5 ),
    PSA::Element::Block->new( from=>9, to=>11 ),
];

my $analysis=PSA::Analysis::Block->new();
my $got = $analysis->analyse($document);

is_deeply( $got, $expected );

# use Data::Dumper;print Dumper($got);
