package Perl::Analysis::Static::Analysis::Use;

=head2 NAME

Perl::Analysis::Static::Analysis::Use -- What modules are used in a document?

=head2 DESCRIPTION

=cut

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

use Perl::Analysis::Static::Element::Use;

extends 'Perl::Analysis::Static::Analysis';

has '_ppi_class' => ( is => 'rw', isa => 'Str', default => 'PPI::Statement::Include' );

sub _convert {
    my ($self, $node) = @_;

    # get significant children
    my @schildren = $node->schildren();

    # the first child is the keyword
    unless ($schildren[0] eq 'use') {
        # CHECK: log a warning if this isn't the case?
        return;
    }

    # name is the second child
    my $name = $schildren[1];

    return Perl::Analysis::Static::Element::Use->new( name => $name->content());
}

1;
