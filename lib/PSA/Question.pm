package PSA::Question;

=head2 NAME

PSA::Question --

=head2 DESCRIPTION

=cut

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

use Module::Runtime qw(use_module);

use PSA::Document;

has 'class'     => ( is => 'rw', isa => 'Str' );
has 'filter'    => ( is => 'rw', isa => 'ArrayRef[Str]' );
has 'arguments' => ( is => 'rw', isa => 'ArrayRef[Str]' );

=head2 ask ($elements)


=cut

sub ask {
	my ( $self, $files ) = @_;

	my $answer;

	for my $filename (@$files) {
		my $elements = $self->_ask_for_file($filename);

		# don't populate the hash for this file if there's nothing left
		next unless $elements;

		$answer->{$filename} = $elements;
	}

	return $answer;
}

sub set_arguments {
	my ($self) = @_;
	die 'implement me';
}

=head2 _filter ($elements)

=cut

sub _filter {
	my ( $self, $elements ) = @_;

	my @filters   = @{ $self->filter };
	my @arguments = @{ $self->arguments };

	for my $filter_class (@filters) {

		# preprend PSA::Filter if it's not already there
		unless ( $filter_class =~ m{^PSA::Filter::} ) {
			$filter_class = 'PSA::Filter::' . $filter_class;
		}

		# load the filter's module
		use_module($filter_class);

		# create instance and set its arguments
		my $filter    = $filter_class->new();
		my $arguments = shift @arguments;
		$filter->set_arguments($arguments);

		# filter the elements
		$elements = $filter->filter($elements);
	}
	return $elements;
}

sub _ask_for_file {
	my ( $self, $filename ) = @_;
	my $document = PSA::Document->new( filename => $filename );
	unless ($document) {
		App::Perlanalyst::die(
			"Unable to get document instance for file '$filename'");
	}

	# find all elements of this class
	my $elements = $document->find( $self->class() );

	# return if we didn't find anything
	return unless $elements;

	# filter the elements if we have to
	return $self->_filter($elements) if $self->{filter};
}

1;
