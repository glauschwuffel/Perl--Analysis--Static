#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('Perl::Analysis::Static::Document');
    use_ok('Perl::Analysis::Static::Element::Block');
    use_ok('Perl::Analysis::Static::Analysis::Block');
}

my $filename='t/data/lexicals_and_blocks.pl';
my $document = Perl::Analysis::Static::Document->new(filename => $filename);

my $expected = [
    Perl::Analysis::Static::Element::Block->new( from=>2, to=>5 ),
    Perl::Analysis::Static::Element::Block->new( from=>9, to=>11 ),
];

my $analysis=Perl::Analysis::Static::Analysis::Block->new();
my $got = $analysis->analyse($document);

is_deeply( $got, $expected );

# use Data::Dumper;print Dumper($got);
