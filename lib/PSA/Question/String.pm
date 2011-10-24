package PSA::Question::String;

=head2 NAME

PSA::Question::String

=head2 DESCRIPTION

=cut

use Moose;

extends 'PSA::Question';

sub set_arguments {
	my ($self, $arguments) = @_;
	$self->class('PSA::Element::String');
	$self->filter(    ['String'] );
	$self->arguments( [split(/:/, $arguments)] );
}

1;
