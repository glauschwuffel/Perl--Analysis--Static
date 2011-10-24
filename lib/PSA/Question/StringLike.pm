package PSA::Question::StringLike;

=head2 NAME

PSA::Question::StringLike

=head2 DESCRIPTION

=cut

use Moose;

extends 'PSA::Question';

sub set_arguments {
	my ($self, $arguments) = @_;
	$self->class('PSA::Element::String');
	$self->filter(    ['StringLike'] );
	$self->arguments( [split(/:/, $arguments)] );
}

1;
