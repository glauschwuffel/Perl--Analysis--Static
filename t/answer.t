#! /usr/bin/env perl

use Test::Most 'no_plan';

BEGIN {
    use_ok('Perl::Analysis::Static::Element::Sub');
    use_ok('Perl::Analysis::Static::Answer');
}

# create instance
my $answer = Perl::Analysis::Static::Answer->new(
    class     => 'Perl::Analysis::Static::Element::Sub'
);
isa_ok($answer, 'Perl::Analysis::Static::Answer');

# add element
my $element = [
		Perl::Analysis::Static::Element::Sub->new(
			name => 'function',
			from => 2,
			to   => 4
		)
	];

ok($answer->add_element($element), 'add element');

cmp_deeply($answer->elements, [$element]);

# use Data::Dumper;print Dumper($got);
