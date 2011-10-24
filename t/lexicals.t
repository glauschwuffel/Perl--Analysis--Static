#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('Perl::Analysis::Static::Document');
    use_ok('Perl::Analysis::Static::Element::Lexical');
    use_ok('Perl::Analysis::Static::Analysis::Lexical');
}

my $filename='t/data/lexicals_and_blocks.pl';

my $document = Perl::Analysis::Static::Document->new(filename => $filename);

my $expected = [
    Perl::Analysis::Static::Element::Lexical->new( name => '$a', from => 1, to=> 1 ),
    Perl::Analysis::Static::Element::Lexical->new( name => '$inner_1_a', from => 3, to=> 3 ),
    Perl::Analysis::Static::Element::Lexical->new( name => '$inner_1_b', from => 4, to=> 4 ),
    Perl::Analysis::Static::Element::Lexical->new( name => '$in_between_b', from => 7, to=> 7 ),
    Perl::Analysis::Static::Element::Lexical->new( name => '$inner_2_a', from => 10, to=> 10 ),
    Perl::Analysis::Static::Element::Lexical->new( name => '$inner_2_b', from => 10, to=> 10 ),
    Perl::Analysis::Static::Element::Lexical->new( name => '$after_a', from => 13, to=> 13 ),
    Perl::Analysis::Static::Element::Lexical->new( name => '$after_b', from => 14, to=> 14 )
];

my $analysis=Perl::Analysis::Static::Analysis::Lexical->new();
my $got = $analysis->analyse($document);

is_deeply( $got, $expected );

# use Data::Dumper;print Dumper($got);
