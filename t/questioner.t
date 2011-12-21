#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('Perl::Analysis::Static::Element::Sub');
    use_ok('Perl::Analysis::Static::Question::Sub::Name');
    use_ok('Perl::Analysis::Static::Questioner');
}

my $filename = 't/data/subs.pl';

my $expected = [
    Perl::Analysis::Static::Element::Sub->new(
        name => 'function',
        from => 2,
        to   => 4
    )
];

my $question = Perl::Analysis::Static::Question::Sub::Name->new();
$question->set_arguments('function');

my $questioner = Perl::Analysis::Static::Questioner->new();
my $answer = $questioner->ask_for_file( $question, $filename );
isa_ok( $answer, 'Perl::Analysis::Static::Answer' ) or BAIL_OUT;

# remove the PPI nodes for the comparison
my $got = $answer->elements();
delete $_->{ppi_node} for @$got;

is_deeply( $got, $expected );

# use Data::Dumper;print Dumper($got);
