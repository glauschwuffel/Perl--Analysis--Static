package Perl::Analysis::Static::Question::Lexical::Name;

=head2 NAME

Perl::Analysis::Static::Question::Lexical::Name -- Where's the lexical variable of that name?

=head2 DESCRIPTION

=cut

use Moose;

extends 'Perl::Analysis::Static::Question';

sub set_arguments {
	my ($self, $arguments) = @_;
	$self->class('Perl::Analysis::Static::Element::Lexical');
	$self->filter(    ['Name'] );
	$self->arguments( [split(/:/, $arguments)] );
}

1;
