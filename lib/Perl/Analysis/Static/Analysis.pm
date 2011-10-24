package Perl::Analysis::Static::Analysis;

=head2 NAME

Perl::Analysis::Static::Analysis -- Find out something about a document

=head2 DESCRIPTION

=cut

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

has '_ppi_class' => ( is => 'rw', isa => 'Str', default => 'PPI::Node' );

=head2 analyse ($document)

Find nodes of a given PPI class in the PPI representation of a
document and convert each one.

Returns reference to list of converted nodes.

=cut

sub analyse {
    my ( $self, $document ) = @_;

    # find all nodes of given PPI class
    my $nodes = $document->ppi->find( sub { $_[1]->isa($self->_ppi_class) } );

	# return immediately if there were no nodes of this class
	return unless $nodes;
	
    # convert them
#    my @findings = map { $self->_convert($_) } @$nodes;
	my @findings;
	for my $node (@$nodes) {
		push @findings, $self->_convert($node);
	}

	# return immediately if we didn't find anything or we get an empty list
	return unless @findings;
	
    return \@findings;
}

sub _convert {
    my ( $self, $ppi_node ) = @_;
    
    die 'implement me';
}

1;
