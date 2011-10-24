package Perl::Analysis::Static::Filter;

=head2 NAME

Perl::Analysis::Static::Filter --

=head2 DESCRIPTION

=cut

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

=head2 set_arguments ($arguments)

=cut

sub set_arguments {
    my ($self, $arguments)=@_;

	my @args=split(/:/, $arguments);
	$self->_set_arguments(\@args);
}

=head2 filter ($elements)


=cut

sub filter {
	my ( $self, $elements ) = @_;

	my @e = grep { $self->_filter($_) } @$elements;
	return unless @e;
	return \@e;
}

sub _filter {
	my ( $self, $element ) = @_;
	die 'implement me';
}

sub _set_arguments {
	my ( $self, $arguments) = @_;
	die 'implement me';
}

1;
