package Perl::Analysis::Static::Element::PackageVariable;
# ABSTRACT: declaration of a package variable

use Moose;

extends 'Perl::Analysis::Static::Element';

has 'name' => ( is => 'rw', isa => 'Str' );

=head2 stringify ()

=cut

sub stringify {
    my ($self)=@_;
    
    return $self->from.': '.$self->name;
}

1;
