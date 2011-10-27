package Perl::Analysis::Static::Question;
# ABSTRACT: ask a question about a Perl document

=head2 DESCRIPTION

A human or a machine might want to know something about a Perl
document, so it asks a question for that document. Such a question
may be "Where is a lexical variable named 'foo' declared?" or
"What functions are declared whose name match the regex '^[sS]et'?".

Enter this class. It is the base class for all questions asked about
a Perl document.

=cut

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

use Module::Runtime qw(use_module);

use Perl::Analysis::Static::Document;

=attr class

Holds the name of the element that you ask for. It's a string
that gets L<Perl::Statis::Analysis::Element> appended. 

=cut

has 'class'     => ( is => 'rw', isa => 'Str' );

=attr filter

When a question is asked it gets a list of elements
(which are subclasses of L<Perl::Statis::Analysis::Element>).
The list is then filtered by any number of filters (or no
filter at all.)

The names of the filters are stored in this attribut. It's a
reference to a list of strings, each one gets
L<Perl::Statis::Analysis::Filter> appended. 

=cut

has 'filter'    => ( is => 'rw', isa => 'ArrayRef[Str]' );

=attr arguments

Reference to list of arguments for each filter.

=cut

has 'arguments' => ( is => 'rw', isa => 'ArrayRef[Str]' );

=head2 ask ($file)

Asks the question for a file. First we try to create
a L<Perl::Analysis::Static::Document> from the file. We throw
an expection if we cannot do this. This most likely means that
the file contains no Perl document, since L<PPI> is unable to
parse it.

If the parsing was successful, we search for the elements specified
by the class name in our C<class> attribute.

If we didn't find any elements, we return immediately with undef.
Hoewever, if we have found something, we run our filters over
it. We return the result of the filters which might be a reference
to a list of elements. If we filtered everything and nothing is left,
we return undef.

=cut

sub ask {
	my ( $self, $filename ) = @_;
	
	my $document = Perl::Analysis::Static::Document->new( filename => $filename );
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

		# preprend Perl::Analysis::Static::Filter if it's not already there
		unless ( $filter_class =~ m{^Perl::Analysis::Static::Filter::} ) {
			$filter_class = 'Perl::Analysis::Static::Filter::' . $filter_class;
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

1;
