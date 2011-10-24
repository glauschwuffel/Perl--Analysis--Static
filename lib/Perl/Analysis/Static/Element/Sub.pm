package Perl::Analysis::Static::Element::Sub;

use Moose;

extends 'Perl::Analysis::Static::Element';

has 'name' => ( is => 'rw', isa => 'Str' );

=head2 stringify

TODO:

tell me if it's a function or a method.
tell me the arguments.
show me the body.

=cut

sub stringify {
    my ($self) = @_;
    return $self->from.'-'.$self->to.': '.$self->name();
}

1;
