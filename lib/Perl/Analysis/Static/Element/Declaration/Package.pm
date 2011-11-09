package Perl::Analysis::Static::Element::Declaration::Package;
# ABSTRACT: declaration of a package

use Moose;

extends 'Perl::Analysis::Static::Element::Declaration';

has 'name' => ( is => 'rw', isa => 'Str' );

=head2 stringify ()

=cut

sub stringify {
    my ($self)=@_;
    
    return $self->from.': '.$self->name;
}

1;