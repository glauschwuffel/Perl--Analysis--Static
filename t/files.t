#! /usr/bin/env perl

use strict;
use warnings;

use Test::More 'no_plan';
use Test::Deep;

BEGIN {
    use_ok('Perl::Analysis::Static::Files');
}

my $dir='t/';
my @got = Perl::Analysis::Static::Files::files($dir);

my @expected = qw(t/blocks.t
t/data/lexicals_and_blocks.pl
t/data/strings.pl
t/data/subs.pl
t/data/uses.pl
t/document.t
t/element.t
t/files.t
t/filter.t
t/lexicals.t
t/question-lexical-name.t
t/question-sub-name.t
t/question.t
t/subs.t
t/use.t
);

is_deeply( \@got, \@expected );

# use Data::Dumper;print Dumper(\@got);
