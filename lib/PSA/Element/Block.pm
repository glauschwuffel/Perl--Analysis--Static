package PSA::Element::Block;

use Moose;

extends 'PSA::Element';

sub stringify {
    my ($self) = @_;
    
    return $self->from.' - '.$self->to;
}

1;
