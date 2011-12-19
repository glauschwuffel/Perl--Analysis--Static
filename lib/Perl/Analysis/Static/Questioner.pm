package Perl::Analysis::Static::Questioner;

# ABSTRACT: ask a question about a Perl document

=head2 DESCRIPTION

=cut

use Moose;
use Carp;
use English qw( -no_match_vars );    # Avoids regex performance penalty

use Module::Runtime qw(use_module);

use Perl::Analysis::Static::Document;
use Perl::Analysis::Static::Answer;
use Perl::Analysis::Static::Collector;

=head2 ask_for_file ($question, $filename)


=cut

sub ask_for_file {
    my ( $self, $question, $filename ) = @_;

    my $document =
        Perl::Analysis::Static::Document->new( filename => $filename );
    unless ($document) {
        App::Perlanalyst::die(
            "Unable to get document instance for file '$filename'");
    }

    return $self->ask_for_document( $question, $document );
}

=head2 ask_for_document ($question, $document)

Asks the question for a document.

If we didn't find any elements, we return immediately with undef.
Hoewever, if we have found something, we run our filters over
it. We return the result of the filters which might be a reference
to a list of elements. If we filtered everything and nothing is left,
we return undef.

=cut

sub ask_for_document {
    my ( $self, $question, $document ) = @_;

    unless ($document) {
        App::Perlanalyst::die('Argument error: need document');
    }

    # find all elements of this class
    my $elements = $document->find( $question->class() );

    # return if we didn't find anything
    return unless $elements;

    # filter the elements if we have to
    $elements = $self->_filter( $question, $elements ) if $question->{filter};

    # return immediately if we filtered everything
    return unless $elements;

    my $answer = Perl::Analysis::Static::Answer->new( elements => $elements );
    return $answer;
}

=head2 ask_for_files ($question, $files, ;$step_hook)

Asks a question for a list of files and collects the answers.

The $step_hook is optional. If provided, it is called with the
file's name as only argument after the answer for that file is added
to the collector.

Results: A collector containing all the answers.

Example:
  my $collector = $questioner->ask_for_files( $question, $files,
                     sub { print shift } );
=cut

sub ask_for_files {
    my ( $self, $question, $files, $step_hook ) = @_;

    my $collector = Perl::Analysis::Static::Collector->new();

    for my $file (@$files) {
        my $answer =
            $self->ask_for_file( $question, $file );
        $collector->set_answer( $file, $answer ) if $answer;
        &$step_hook($file) if $step_hook and ref $step_hook eq 'CODE';
    }
    
    return $collector;
}

=head2 INTERNAL METHODS

=head2 _filter ($question, $elements)

=cut

sub _filter {
    my ( $self, $question, $elements ) = @_;

    my @filters   = @{ $question->filter };
    my @arguments = @{ $question->arguments };

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
