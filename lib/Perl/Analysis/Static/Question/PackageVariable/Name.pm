package Perl::Analysis::Static::Question::PackageVariable::Name;
# ABSTRACT: Does the name of the package variable equal this string?

use Moose;

extends 'Perl::Analysis::Static::Question';

sub set_arguments {
	my ($self, $arguments) = @_;
	$self->class('Perl::Analysis::Static::Element::PackageVariable');
	$self->filter(    ['Name'] );
	$self->arguments( [split(/:/, $arguments)] );
}

1;
