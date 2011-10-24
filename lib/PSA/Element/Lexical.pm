package PSA::Element::Lexical;

use Moose;

extends 'PSA::Element';

has 'name' => ( is => 'rw', isa => 'Str' );

=head2 stringify ()

=cut

sub stringify {
    my ($self)=@_;
    
    return $self->from.': '.$self->name;
}
1;
