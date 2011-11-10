#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('Perl::Analysis::Static::Document');
    use_ok('Perl::Analysis::Static::Element::Declaration::Variable::Package');
    use_ok('Perl::Analysis::Static::Analysis::Declaration::Variable');
}

my $filename='t/data/package_variables.pl';

my $document = Perl::Analysis::Static::Document->new(filename => $filename);

my $expected = [
    Perl::Analysis::Static::Element::Declaration::Variable::Package->new( name => '$foo', from => 4, to=> 4 ),
    Perl::Analysis::Static::Element::Declaration::Variable::Package->new( name => '$bar', from => 5, to=> 5 ),
    Perl::Analysis::Static::Element::Declaration::Variable::Package->new( name => '$baz', from => 5, to=> 5 ),
    Perl::Analysis::Static::Element::Declaration::Variable::Package->new( name => '$foo', from => 9, to=> 9 ),
    Perl::Analysis::Static::Element::Declaration::Variable::Package->new( name => '$bar', from => 10, to=> 10 ),
    Perl::Analysis::Static::Element::Declaration::Variable::Package->new( name => '$baz', from => 10, to=> 10 ),
];

my $analysis=Perl::Analysis::Static::Analysis::Declaration::Variable->new();
my $got = $analysis->analyse($document);

# remove the PPI nodes for the comparison
delete $_->{ppi_node} for @$got;

is_deeply( $got, $expected );

# use Data::Dumper;print Dumper($got);
