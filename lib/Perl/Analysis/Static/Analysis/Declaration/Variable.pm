package Perl::Analysis::Static::Analysis::Declaration::Variable;
# ABSTRACT: find all declarations of variables

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

use Perl::Analysis::Static::Element::Declaration::Variable::Lexical;
use Perl::Analysis::Static::Element::Declaration::Variable::Local;
use Perl::Analysis::Static::Element::Declaration::Variable::Package;

extends 'Perl::Analysis::Static::Analysis';

has '_ppi_class' =>
  ( is => 'rw', isa => 'Str', default => 'PPI::Statement::Variable' );

sub _convert {
	my ( $self, $node ) = @_;

	# get significant children
	my @schildren = $node->schildren();

	# the first child is the keyword, for lexical
	# variables this has to be 'my', for package 'our';
	my $type=_detect_type($schildren[0]);
	
	# maybe a warning here?
	return unless $type;

	my $class='Perl::Analysis::Static::Element::Declaration::Variable::'.$type;
	
	# variable (or list of variables) is the second child
	my $variables = $schildren[1];

	# "my $foo"?
	if ( $variables->isa('PPI::Token::Symbol') ) {
		my $name = $variables->content;

		return $class->new(
			name => $name,
			from => $node->location->[0],
			to   => $node->location->[0]
		);
	}

	# no, not "my $foo", so check for "my ($foo, $bar)"
	# list of variables is found in a PPI::Structure::List
	@schildren = $node->schildren();
	my $list = $schildren[1];
	unless ( $list->isa('PPI::Structure::List') ) {
		App::Perlanalyst::die('PANIC: Expected PPI::Structure::List');
	}

	# variable names are of class PPI::Token::Symbol
	my $symbols = $list->find('PPI::Token::Symbol');
	return map {
		$class->new(
			name => $_->content,
			from => $_->location->[0],
			to   => $_->location->[0]
		);

	} @$symbols;
}

sub _detect_type {
	my ($keyword)=@_;
	return 'Lexical' if $keyword eq 'my';
	return 'Package' if $keyword eq 'our';
	return 'Local' if $keyword eq 'local';

	return;
}

=head1 DESCRIPTION

This analysis looks for variable declarations. It may create three
different kinds of elements:
L<Perl::Analysis::Static::Element::Declaration::Variable::Lexical>
for declaration of lexical variables,
L<Perl::Analysis::Static::Element::Declaration::Variable::Local>
for declaration of local variables,
L<Perl::Analysis::Static::Element::Declaration::Variable::>
for declaration of package variables.

=cut

1;
