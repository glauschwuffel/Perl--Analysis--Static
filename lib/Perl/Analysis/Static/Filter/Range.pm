package Perl::Analysis::Static::Filter::Range;
# ABSTRACT: Does the element lie in this range of lines?

use Moose;

extends 'Perl::Analysis::Static::Filter';

has 'from' => ( is => 'rw', isa => 'Int' );
has 'to'   => ( is => 'rw', isa => 'Int' );

sub _filter {
    my ( $self, $element ) = @_;

#warn "element is ", $element->from(), " - ", $self->to,"\n";
    return 1 if $element->from() >= $self->from()
      and $element->to() <= $self->to();
}

sub _set_arguments {
    my ( $self, $arguments ) = @_;

    $self->from( $arguments->[0] );
    $self->to( $arguments->[1] );

#warn "set args to ", $self->from," - ",$self->to,"\n";
}

1;
