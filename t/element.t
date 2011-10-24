#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('Perl::Analysis::Static::Element::Sub');
}

# stringify
{
    my $sub      = Perl::Analysis::Static::Element::Sub->new( name => 'do_stuff', from => 1, to=>2 );
    my $expected = '1-2: do_stuff';
    my $got      = $sub->stringify();

    is( $got, $expected, 'stringify' );
}
