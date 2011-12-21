package Perl::Analysis::Static::Question::PackageVariable::NameLike;
# ABSTRACT: Does the name of the package variable match this regex?

use Moose;

extends 'Perl::Analysis::Static::Question';

sub set_arguments {
    my ($self, $arguments) = @_;
    $self->class('Perl::Analysis::Static::Element::PackageVariable');
    $self->filter(    ['NameLike'] );
    $self->arguments( [split(/:/, $arguments)] );
}

1;
