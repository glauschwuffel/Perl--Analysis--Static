package Perl::Analysis::Static::Question::Sub::NameLike;

=head2 NAME

Perl::Analysis::Static::Question --

=head2 DESCRIPTION

=cut

use Moose;

extends 'Perl::Analysis::Static::Question';

sub set_arguments {
	my ($self, $arguments) = @_;
	$self->class('Perl::Analysis::Static::Element::Sub');
	$self->filter(    ['NameLike'] );
	$self->arguments( [split(/:/, $arguments)] );
}

1;
