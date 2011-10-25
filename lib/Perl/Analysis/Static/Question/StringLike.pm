package Perl::Analysis::Static::Question::StringLike;

=head2 NAME

Perl::Analysis::Static::Question::StringLike --
What strings look like the argument?

=head2 DESCRIPTION

=cut

use Moose;

extends 'Perl::Analysis::Static::Question';

sub set_arguments {
	my ($self, $arguments) = @_;
	$self->class('Perl::Analysis::Static::Element::String');
	$self->filter(    ['StringLike'] );
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
