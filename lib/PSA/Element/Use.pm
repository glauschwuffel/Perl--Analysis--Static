package PSA::Element::Use;

use Moose;

extends 'PSA::Element';

has 'name' => ( is => 'rw', isa => 'Str' );

=head2 stringify

=cut

sub stringify {
    my ($self) = @_;
    
    return $self->name();
}

1;
