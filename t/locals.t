#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('Perl::Analysis::Static::Document');
    use_ok('Perl::Analysis::Static::Element::Declaration::Variable::Local');
    use_ok('Perl::Analysis::Static::Analysis::Declaration::Variable');
}

my $filename='t/data/locals_and_blocks.pl';

my $document = Perl::Analysis::Static::Document->new(filename => $filename);

my $expected = [
    Perl::Analysis::Static::Element::Declaration::Variable::Local->new( name => '$local_a', from => 2, to=> 2 ),
    Perl::Analysis::Static::Element::Declaration::Variable::Local->new( name => '$local_inner_1_a', from => 4, to=> 4 ),
    Perl::Analysis::Static::Element::Declaration::Variable::Local->new( name => '$local_inner_1_b', from => 5, to=> 5 ),
    Perl::Analysis::Static::Element::Declaration::Variable::Local->new( name => '$local_in_between_b', from => 8, to=> 8 ),
    Perl::Analysis::Static::Element::Declaration::Variable::Local->new( name => '$local_inner_2_a', from => 11, to=> 11 ),
    Perl::Analysis::Static::Element::Declaration::Variable::Local->new( name => '$local_inner_2_b', from => 11, to=> 11 ),
    Perl::Analysis::Static::Element::Declaration::Variable::Local->new( name => '$local_after_a', from => 14, to=> 14 ),
    Perl::Analysis::Static::Element::Declaration::Variable::Local->new( name => '$local_after_b', from => 15, to=> 15 )
];

my $analysis=Perl::Analysis::Static::Analysis::Declaration::Variable->new();
my $got = $analysis->analyse($document);

# remove the PPI nodes for the comparison
delete $_->{ppi_node} for @$got;

is_deeply( $got, $expected );

# use Data::Dumper;print Dumper($got);
