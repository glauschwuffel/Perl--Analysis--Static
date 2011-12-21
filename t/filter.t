#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('Perl::Analysis::Static::Document');
    use_ok('Perl::Analysis::Static::Element::Sub');
    use_ok('Perl::Analysis::Static::Filter');
}

my $filename = 't/data/subs.pl';
my $document = Perl::Analysis::Static::Document->new( filename => $filename );

my $elements = [
    Perl::Analysis::Static::Element::Sub->new( name => 'function' ),
    Perl::Analysis::Static::Element::Sub->new( name => 'method' ),
];

{
    no warnings 'redefine';
    *Perl::Analysis::Static::Filter::_filter = sub {
        my ( $self, $element ) = @_;
        return 1 if $element->name eq 'function';
    };
    use warnings 'redefine';

    my $filter   = Perl::Analysis::Static::Filter->new();
    my $expected = [ $elements->[0] ];
    my $got      = $filter->filter($elements);

    is_deeply( $got, $expected );

}

{
    no warnings 'redefine';
    *Perl::Analysis::Static::Filter::_filter = sub {
        my ( $self, $element ) = @_;
        return 1 if $element->name eq 'method';
    };
    use warnings 'redefine';

    my $filter   = Perl::Analysis::Static::Filter->new();
    my $expected = [ $elements->[1] ];
    my $got      = $filter->filter($elements);

    is_deeply( $got, $expected );

}

# use Data::Dumper;print Dumper($got);
