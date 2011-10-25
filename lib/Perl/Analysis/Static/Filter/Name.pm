package Perl::Analysis::Static::Filter::Name;

use Moose;

extends 'Perl::Analysis::Static::Filter';

has 'name' => ( is => 'rw', isa => 'Str' );

sub _filter {
    my ($self, $element) = @_;
    
    return 1 if $self->name() eq $element->name();
}

sub _set_arguments {
    my ($self, $arguments) = @_;

	$self->name($arguments->[0]);    
}

=head1 AUTHOR

Gregor Goldbach, glauschwuffel@nomaden.org

=head1 COPYRIGHT & LICENSE

Copyright 2011 Gregor Goldbach

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License v2.0.

=cut

1;
