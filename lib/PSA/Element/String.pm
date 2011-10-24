package PSA::Element::String;

use Moose;

extends 'PSA::Element';

has 'string' => ( is => 'rw', isa => 'Str' );

=head2 stringify

=cut

sub stringify {
    my ($self) = @_;
    
    return $self->from.': '.$self->string();
}

1;
