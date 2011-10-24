#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('Perl::Analysis::Static::Document');
    use_ok('Perl::Analysis::Static::Element::Sub');
}

my $filename='t/data/subs.pl';
my $document = Perl::Analysis::Static::Document->new(filename => $filename);

my $expected = [
    Perl::Analysis::Static::Element::Sub->new( name => 'function', from => 1, to => 3 ),
    Perl::Analysis::Static::Element::Sub->new( name => 'method', from => 5, to => 7 ),
];

my $got = $document->find('Perl::Analysis::Static::Element::Sub');

is_deeply( $got, $expected );

#use Data::Dumper;print Dumper($got);
