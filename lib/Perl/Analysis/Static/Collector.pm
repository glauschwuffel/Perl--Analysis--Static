package Perl::Analysis::Static::Collector;

# ABSTRACT: collects answers to questions about a Perl documents

=head2 DESCRIPTION

=cut

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

# with the help of Moose::Meta::Attribute::Native::Trait::Hash
has 'answers' => (
    traits  => ['Hash'],
    is      => 'ro',
    isa     => 'HashRef',
    default => sub { {} },
    handles => {
        set_answer     => 'set',
        get_answer     => 'get',
        has_no_answers => 'is_empty',
        num_answers    => 'count',
        delete_answers => 'delete',
        answer_pairs   => 'kv',
        filenames          => 'keys'
        }
);

1;
