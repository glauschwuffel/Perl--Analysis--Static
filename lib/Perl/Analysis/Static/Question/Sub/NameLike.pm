package Perl::Analysis::Static::Question::Sub::NameLike;
# ABSTRACT: What name of a subroutine matches this regex?

use Moose;

extends 'Perl::Analysis::Static::Question';

sub set_arguments {
    my ($self, $arguments) = @_;
    $self->class('Perl::Analysis::Static::Element::Sub');
    $self->filter(    ['NameLike'] );
    $self->arguments( [split(/:/, $arguments)] );
}

1;
