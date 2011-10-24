#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('Perl::Analysis::Static::Document');
    use_ok('Perl::Analysis::Static::Element::Use');
    use_ok('Perl::Analysis::Static::Analysis::Use');
}

my $filename='t/data/uses.pl';
my $document = Perl::Analysis::Static::Document->new(filename => $filename);

my $expected = [
    Perl::Analysis::Static::Element::Use->new( name => 'A' ),
    Perl::Analysis::Static::Element::Use->new( name => 'B' ),
];

my $analysis=Perl::Analysis::Static::Analysis::Use->new();
my $got = $analysis->analyse($document);

is_deeply( $got, $expected );

use Data::Dumper;print Dumper($got);
