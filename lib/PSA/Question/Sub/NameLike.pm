package PSA::Question::Sub::NameLike;

=head2 NAME

PSA::Question --

=head2 DESCRIPTION

=cut

use Moose;

extends 'PSA::Question';

sub set_arguments {
	my ($self, $arguments) = @_;
	$self->class('PSA::Element::Sub');
	$self->filter(    ['NameLike'] );
	$self->arguments( [split(/:/, $arguments)] );
}

1;
