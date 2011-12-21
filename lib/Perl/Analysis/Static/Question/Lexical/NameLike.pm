package Perl::Analysis::Static::Question::Lexical::NameLike;
# ABSTRACT: Does the name of the lexical variable match this regex?

use Moose;

extends 'Perl::Analysis::Static::Question';

sub set_arguments {
    my ($self, $arguments) = @_;
    $self->class('Perl::Analysis::Static::Element::Lexical');
    $self->filter(    ['NameLike'] );
    $self->arguments( [split(/:/, $arguments)] );
}

1;
