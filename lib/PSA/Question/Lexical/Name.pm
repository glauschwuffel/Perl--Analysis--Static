package PSA::Question::Lexical::Name;

=head2 NAME

PSA::Question::Lexical::Name -- Where's the lexical variable of that name?

=head2 DESCRIPTION

=cut

use Moose;

extends 'PSA::Question';

sub set_arguments {
	my ($self, $arguments) = @_;
	$self->class('PSA::Element::Lexical');
	$self->filter(    ['Name'] );
	$self->arguments( [split(/:/, $arguments)] );
}

1;
