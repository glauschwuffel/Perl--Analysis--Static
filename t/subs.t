#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('Perl::Analysis::Static::Document');
    use_ok('Perl::Analysis::Static::Element::Sub');
    use_ok('Perl::Analysis::Static::Analysis::Sub');
}

my $filename='t/data/subs.pl';
my $document = Perl::Analysis::Static::Document->new(filename => $filename);

my $expected = [
    Perl::Analysis::Static::Element::Sub->new( name => 'function', from => 2, to => 4 ),
    Perl::Analysis::Static::Element::Sub->new( name => 'method', from => 6, to => 8 ),
];

my $analysis=Perl::Analysis::Static::Analysis::Sub->new();
my $got = $analysis->analyse($document);

# remove the PPI nodes for the comparison
delete $_->{ppi_node} for @$got;

is_deeply( $got, $expected );

# use Data::Dumper;print Dumper($got);
