#! /usr/bin/env perl

use Test::Most 'no_plan';

BEGIN {
    use_ok('Perl::Analysis::Static::Element::Sub');
    use_ok('Perl::Analysis::Static::Collector');
    use_ok('Perl::Analysis::Static::Answer');
}

# create instance
my $collector = Perl::Analysis::Static::Collector->new();
isa_ok($collector, 'Perl::Analysis::Static::Collector');

# create instance
my $answer = Perl::Analysis::Static::Answer->new(
    class     => 'Perl::Analysis::Static::Element::Sub'
);
isa_ok($answer, 'Perl::Analysis::Static::Answer');

$collector->set_answer('any file', $answer);

# use Data::Dumper;print Dumper($got);
