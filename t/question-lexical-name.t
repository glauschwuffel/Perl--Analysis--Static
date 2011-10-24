#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
	use_ok('Perl::Analysis::Static::Element::Lexical');
	use_ok('Perl::Analysis::Static::Question::Lexical::Name');
}

my $filename = 't/data/lexicals_and_blocks.pl';

my $expected = {
	$filename => [
		Perl::Analysis::Static::Element::Lexical->new(
			name => '$a',
			from => 1,
			to   => 1
		)
	]
};

my $question = Perl::Analysis::Static::Question::Lexical::Name->new();
$question->set_arguments('$a');
my $got = $question->ask( [$filename] );
is_deeply( $got, $expected );

# use Data::Dumper;print Dumper($got);
