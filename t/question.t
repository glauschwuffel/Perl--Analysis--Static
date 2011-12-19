#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('Perl::Analysis::Static::Element::Sub');
    use_ok('Perl::Analysis::Static::Question');
}

my $got = Perl::Analysis::Static::Question->new(
    class     => 'Perl::Analysis::Static::Element::Sub',
    filter    => ['Name'],
    arguments => ['function']
);
isa_ok($got, 'Perl::Analysis::Static::Question');

# use Data::Dumper;print Dumper($got);
