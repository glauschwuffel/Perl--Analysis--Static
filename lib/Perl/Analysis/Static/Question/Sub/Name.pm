package Perl::Analysis::Static::Question::Sub::Name;
# ABSTRACT: Has the subroutine this name?

use Moose;

extends 'Perl::Analysis::Static::Question';

sub set_arguments {
    my ($self, $arguments) = @_;
    $self->class('Perl::Analysis::Static::Element::Sub');
    $self->filter(    ['Name'] );
    $self->arguments( [split(/:/, $arguments)] );
}

1;
