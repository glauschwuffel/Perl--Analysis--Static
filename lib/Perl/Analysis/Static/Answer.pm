package Perl::Analysis::Static::Answer;
# ABSTRACT: represents an answer to a question about a Perl document

=head2 DESCRIPTION

=cut

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

has 'class'     => ( is => 'rw', isa => 'Str' );

has 'elements' => (
        traits  => ['Array'],
        is      => 'ro',
        isa     => 'ArrayRef',
        default => sub { [] },
        handles => {
            add_element  => 'push'
        }
);

1;
