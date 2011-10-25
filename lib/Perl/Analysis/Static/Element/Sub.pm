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

=head1 AUTHOR

Gregor Goldbach, glauschwuffel@nomaden.org

=head1 COPYRIGHT & LICENSE

Copyright 2011 Gregor Goldbach

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License v2.0.

=cut

1;
