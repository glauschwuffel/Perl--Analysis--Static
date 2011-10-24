#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
	use_ok('PSA::Element::Sub');
	use_ok('PSA::Question');
}

my $filename = 't/data/subs.pl';

my $expected = {
	$filename => [
		PSA::Element::Sub->new(
			name => 'function',
			from => 1,
			to   => 3
		)
	]
};

my $question = PSA::Question->new();
$question->class('PSA::Element::Sub');
$question->filter( ['Name'] );
$question->arguments( ['function'] );
my $got = $question->ask( [$filename] );
is_deeply( $got, $expected );

# use Data::Dumper;print Dumper($got);
