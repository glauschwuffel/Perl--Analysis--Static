package Perl::Analysis::Static::Question::Sub::NameLike;

=head2 NAME

Perl::Analysis::Static::Question::Sub::NameLike --
What subs are named like the argument?

=head2 DESCRIPTION

Asks for nodes of the class Element::Sub and filters them
by NameLike.

=cut

use Moose;

extends 'Perl::Analysis::Static::Question';

sub set_arguments {
	my ($self, $arguments) = @_;
	$self->class('Perl::Analysis::Static::Element::Sub');
	$self->filter(    ['NameLike'] );
	$self->arguments( [split(/:/, $arguments)] );
}

=head1 AUTHOR

Gregor Goldbach, glauschwuffel@nomaden.org

=head1 COPYRIGHT & LICENSE

Copyright 2011 Gregor Goldbach

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License v2.0.

=cut

1;
