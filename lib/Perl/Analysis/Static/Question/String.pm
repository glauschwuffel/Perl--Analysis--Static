package Perl::Analysis::Static::Question::String;
# ABSTRACT: What string equals this one?

use Moose;

extends 'Perl::Analysis::Static::Question';

sub set_arguments {
    my ($self, $arguments) = @_;
    $self->class('Perl::Analysis::Static::Element::String');
    $self->filter(    ['String'] );
    $self->arguments( [split(/:/, $arguments)] );
}

1;
