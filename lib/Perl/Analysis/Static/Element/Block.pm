package Perl::Analysis::Static::Element::Block;

use Moose;

extends 'Perl::Analysis::Static::Element';

sub stringify {
    my ($self) = @_;
    
    return $self->from.' - '.$self->to;
}

1;
