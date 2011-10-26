package Perl::Analysis::Static::Question;

=head2 NAME

Perl::Analysis::Static::Question -- Base class for questions

=head2 DESCRIPTION

A question combines searches for elements and filters.
This is the base class.

=cut

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

use Module::Runtime qw(use_module);

use Perl::Analysis::Static::Document;

has 'class'     => ( is => 'rw', isa => 'Str' );
has 'filter'    => ( is => 'rw', isa => 'ArrayRef[Str]' );
has 'arguments' => ( is => 'rw', isa => 'ArrayRef[Str]' );

=head2 ask ($file)

Asks the question for a file.

Result: The answer.

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

=head1 AUTHOR

Gregor Goldbach, glauschwuffel@nomaden.org

=head1 COPYRIGHT & LICENSE

Copyright 2011 Gregor Goldbach

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License v2.0.

=cut

1;
