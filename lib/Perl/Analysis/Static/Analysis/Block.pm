package Perl::Analysis::Static::Analysis::Block;
# ABSTRACT: find all blocks

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

use Perl::Analysis::Static::Element::Block;

extends 'Perl::Analysis::Static::Analysis';

has '_ppi_class' => ( is => 'rw', isa => 'Str', default => 'PPI::Structure::Block' );

sub _convert {
    my ($self, $node) = @_;

    # todo: error check ;)
    return Perl::Analysis::Static::Element::Block->new(
        from => $node->start->location->[0],
        to   => $node->finish->location->[0]
    );

}

1;
