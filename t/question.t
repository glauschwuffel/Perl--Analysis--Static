#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
	use_ok('Perl::Analysis::Static::Element::Sub');
	use_ok('Perl::Analysis::Static::Question');
}

my $filename = 't/data/subs.pl';

my $expected = {
	$filename => [
		Perl::Analysis::Static::Element::Sub->new(
			name => 'function',
			from => 1,
			to   => 3
		)
	]
};

my $question = Perl::Analysis::Static::Question->new();
$question->class('Perl::Analysis::Static::Element::Sub');
$question->filter( ['Name'] );
$question->arguments( ['function'] );
my $got = $question->ask( [$filename] );
is_deeply( $got, $expected );

# use Data::Dumper;print Dumper($got);
