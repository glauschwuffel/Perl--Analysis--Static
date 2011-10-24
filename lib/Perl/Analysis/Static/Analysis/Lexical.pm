package Perl::Analysis::Static::Analysis::Lexical;

=head2 NAME

Perl::Analysis::Static::Analysis::Lexical -- What lexicals are defined in a document?

=head2 DESCRIPTION

TODO

Diese Analyse basiert auf PPI::Statement::Variable.
Damit werden nicht nur lexikalische, sondern z.B. auch Paketvariablen
gefunden.

Also: Entweder die Methode, die die PPI::Statement::Variable raussucht,
mit Memoize versehen, damit sie in mehreren Analysen quasi ohne Zeitverlust
aufgerufen werden kann (und dann eine Analyse pro Variablenart).

Oder diese Analyse umbenennen und alle Variablentypen abfrühstücken.

Letzteres macht diese Analyse größer, komplexer und unübersichtlicher.

Hm ...

=cut

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

use Perl::Analysis::Static::Element::Lexical;

extends 'Perl::Analysis::Static::Analysis';

has '_ppi_class' =>
  ( is => 'rw', isa => 'Str', default => 'PPI::Statement::Variable' );

# return undef if node is not 'my' declaration or not a single variable
sub _convert {
	my ( $self, $node ) = @_;

	# get significant children
	my @schildren = $node->schildren();

	# the first child is the keyword, for lexical
	# variables this has to be 'my'
	return unless $schildren[0] eq 'my';

	# variable (or list of variables) is the second child
	my $variables = $schildren[1];

	if ( $variables->isa('PPI::Token::Symbol') ) {
		# we have a single "my $foo"
		my $name = $variables->content;
		return Perl::Analysis::Static::Element::Lexical->new(
			name => $name,
			from => $node->location->[0],
			to   => $node->location->[0]
		);
	}

	# list of variables is found in a PPI::Structure::List
	@schildren = $node->schildren();
	my $list = $schildren[1];
	unless ( $list->isa('PPI::Structure::List') ) {
		App::Perlanalyst::die('PANIC: Expected PPI::Structure::List');
	}

	# variable names are of class PPI::Token::Symbol
	my $symbols = $list->find('PPI::Token::Symbol');
	return map {
		Perl::Analysis::Static::Element::Lexical->new(
			name => $_->content,
			from => $_->location->[0],
			to   => $_->location->[0]
		);

	} @$symbols;
}

1;
