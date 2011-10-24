#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
	use_ok('PSA::Document');
	use_ok('PSA::Element::Sub');
	use_ok('PSA::Filter');
}

my $filename = 't/data/subs.pl';
my $document = PSA::Document->new( filename => $filename );

my $elements = [
	PSA::Element::Sub->new( name => 'function' ),
	PSA::Element::Sub->new( name => 'method' ),
];

{
	no warnings 'redefine';
	*PSA::Filter::_filter = sub {
		my ( $self, $element ) = @_;
		return 1 if $element->name eq 'function';
	};
	use warnings 'redefine';

	my $filter   = PSA::Filter->new();
	my $expected = [ $elements->[0] ];
	my $got      = $filter->filter($elements);

	is_deeply( $got, $expected );

}

{
	no warnings 'redefine';
	*PSA::Filter::_filter = sub {
		my ( $self, $element ) = @_;
		return 1 if $element->name eq 'method';
	};
	use warnings 'redefine';

	my $filter   = PSA::Filter->new();
	my $expected = [ $elements->[1] ];
	my $got      = $filter->filter($elements);

	is_deeply( $got, $expected );

}

# use Data::Dumper;print Dumper($got);
