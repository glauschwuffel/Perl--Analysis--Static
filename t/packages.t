#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('Perl::Analysis::Static::Document');
    use_ok('Perl::Analysis::Static::Element::Declaration::Package');
    use_ok('Perl::Analysis::Static::Analysis::Declaration::Package');
}

my $filename='t/data/package_variables.pl';

my $document = Perl::Analysis::Static::Document->new(filename => $filename);

my $expected = [
    Perl::Analysis::Static::Element::Declaration::Package->new( name => 'A', from => 2, to=> 2 ),
    Perl::Analysis::Static::Element::Declaration::Package->new( name => 'B', from => 7, to=> 7 ),
];

my $analysis=Perl::Analysis::Static::Analysis::Declaration::Package->new();
my $got = $analysis->analyse($document);

# remove the PPI nodes for the comparison
delete $_->{ppi_node} for @$got;

is_deeply( $got, $expected );

# use Data::Dumper;print Dumper($got);
