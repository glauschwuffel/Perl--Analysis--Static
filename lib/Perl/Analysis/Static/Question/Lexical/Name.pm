package Perl::Analysis::Static::Question::Lexical::Name;
# ABSTRACT: Does the name of the lexical variable equal this string?

use Moose;

extends 'Perl::Analysis::Static::Question';

sub set_arguments {
	my ($self, $arguments) = @_;
	$self->class('Perl::Analysis::Static::Element::Declaration::Variable');
	$self->filter(    ['Name'] );
	$self->arguments( [split(/:/, $arguments)] );
}

1;
