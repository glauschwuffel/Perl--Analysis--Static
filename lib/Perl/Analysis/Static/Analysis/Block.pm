package Perl::Analysis::Static::Analysis::Block;

=head2 NAME

Perl::Analysis::Static::Analysis::Block -- What block are defined in a document?

=head2 DESCRIPTION

=cut

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

=head1 AUTHOR

Gregor Goldbach, glauschwuffel@nomaden.org

=head1 COPYRIGHT & LICENSE

Copyright 2011 Gregor Goldbach

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License v2.0.

=cut

1;
