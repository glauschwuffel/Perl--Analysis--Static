package Perl::Analysis::Static::Analysis::String;

=head2 NAME

Perl::Analysis::Static::Analysis::String -- What strings are used in a document?

=head2 DESCRIPTION

=cut

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

use Perl::Analysis::Static::Element::String;

extends 'Perl::Analysis::Static::Analysis';

has '_ppi_class' =>
  ( is => 'rw', isa => 'Str', default => 'PPI::Token::Quote' );

sub _convert {
	my ( $self, $node ) = @_;
	return Perl::Analysis::Static::Element::String->new(
		string => $node->string(),
		from   => $node->location->[0],
		to     => $node->location->[0]
	);
}

1;
