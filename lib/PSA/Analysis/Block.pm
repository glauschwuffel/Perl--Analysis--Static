package PSA::Analysis::Block;

=head2 NAME

PSA::Analysis::Block -- What block are defined in a document?

=head2 DESCRIPTION

=cut

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

use PSA::Element::Block;

extends 'PSA::Analysis';

has '_ppi_class' => ( is => 'rw', isa => 'Str', default => 'PPI::Structure::Block' );

sub _convert {
    my ($self, $node) = @_;

    # todo: error check ;)
    return PSA::Element::Block->new(
        from => $node->start->location->[0],
        to   => $node->finish->location->[0]
    );

}

1;
