package Perl::Analysis::Static::Element::Use;
# ABSTRACT: module import via use

use Moose;

extends 'Perl::Analysis::Static::Element';

has 'name' => ( is => 'rw', isa => 'Str' );

=head2 stringify

=cut

sub stringify {
    my ($self) = @_;
    
    return $self->name();
}

1;
