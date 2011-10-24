#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('PSA::Document');
    use_ok('PSA::Element::Use');
    use_ok('PSA::Analysis::Use');
}

my $filename='t/data/uses.pl';
my $document = PSA::Document->new(filename => $filename);

my $expected = [
    PSA::Element::Use->new( name => 'A' ),
    PSA::Element::Use->new( name => 'B' ),
];

my $analysis=PSA::Analysis::Use->new();
my $got = $analysis->analyse($document);

is_deeply( $got, $expected );

use Data::Dumper;print Dumper($got);
