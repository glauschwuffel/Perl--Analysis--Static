package Perl::Analysis::Static::Question::StringLike;

=head2 NAME

Perl::Analysis::Static::Question::StringLike

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

1;
