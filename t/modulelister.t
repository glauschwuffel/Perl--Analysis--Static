#! /usr/bin/env perl

use strict;
use warnings;

use Test::Most qw(no_plan bail);

BEGIN {
    use_ok('Perl::Analysis::Static::ModuleLister');
}

# provide kind that won't lead to a namespace we find anything in
{
    my $ml =
      Perl::Analysis::Static::ModuleLister->new( kind => 'Youwontfindme' );
    isa_ok( $ml, 'Perl::Analysis::Static::ModuleLister' );

    my $expected = undef;
    my $got      = $ml->list();
    is( $got, $expected, 'invalid type finds nothing' );
}

# now let's see if there are any questions
{

    # search in our own lib
    push @INC, 'lib';

    my $ml = Perl::Analysis::Static::ModuleLister->new( kind => 'Question' );
    isa_ok( $ml, 'Perl::Analysis::Static::ModuleLister' );

    # check if we got anything at all
    my $questions = $ml->list();
    isa_ok( $questions, 'ARRAY', 'we seem to have found questions' );

    # we should have found at least one
    my $got      = ( scalar @$questions ) > 1;
    my $expected = 1;
    eq_or_diff( $got, $expected, 'at least one question found' );
}

# use Data::Dumper;print Dumper($got);
