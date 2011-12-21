package Perl::Analysis::Static::Question::StringLike;
# ABSTRACT: What string looks like the argument?

use Moose;

extends 'Perl::Analysis::Static::Question';

sub set_arguments {
    my ($self, $arguments) = @_;
    $self->class('Perl::Analysis::Static::Element::String');
    $self->filter(    ['StringLike'] );
    $self->arguments( [split(/:/, $arguments)] );
}

1;
