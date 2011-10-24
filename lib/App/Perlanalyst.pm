package App::Perlanalyst;

use strict;
use warnings;

use Cwd;
use English qw( -no_match_vars );    # Avoids regex performance penalty
use Getopt::Long;
use IO::Interactive qw(is_interactive);
use Module::Runtime qw(use_module);
use Term::ANSIColor qw(colored);

use PSA::Document;
use PSA::Question;
use PSA::Files;

=head2 new

The C<new> constructor is quite trivial at this point, and is provided
merely as a convenience. You don't really need to think about this.

=cut

sub new {
	return bless {}, shift;
}

# TODO: rc-file
sub process_args {
	my ( $self, @args ) = @_;

	{

		# Getopt::Long processes ARGV
		local @ARGV = @args;
		Getopt::Long::Configure(qw(no_ignore_case bundling pass_through));

		# Don't add coderefs to GetOptions
		GetOptions(
			'a|analysis|all=s'           => \$self->{analysis},
			'f|filter=s'             => \@{ $self->{filter} },
			'F|filter-arguments=s'   => \@{ $self->{filter_arguments} },
			'h|help|?'               => \$self->{show_help},
			'q|question=s'           => \$self->{question},
			'Q|question-arguments=s' => \$self->{question_arguments},
			'v|verbose!'             => \$self->{verbose},
		  )
		  or App::Perlanalyst::die('Unable to parse options');

		# Stash the remainder of argv for later
		$self->{argv} = [@ARGV];
	}
}

sub run {
	my ($self) = @_;

	if ( $self->{analysis} ) {
		return $self->analyse() if $self->{analysis};
	}

	# ask questions if specified
	if ( $self->{question} ) {
		my $answer=$self->_ask_question( $self->_files() );
		return $self->_print_answer($answer);
	}

	# there is neither an analysis or a question ...
	App::Perlanalyst::die('What am I supposed to do?');
}

# stolen from von App::Ack
sub die {
	my $program = File::Basename::basename($0);
	return CORE::die( $program, ': ', @_, "\n" );
}


sub analyse {
	my ($self) = @_;

	my $element_class = $self->{analysis};

	# preprend PSA::Element if it's not already there
	unless ( $element_class =~ m{^PSA::Element::} ) {
		$element_class = 'PSA::Element::' . $element_class;
	}

	my $question = PSA::Question->new();
	$question->class($element_class);
	$question->filter( $self->{filter} );
	$question->arguments( $self->{filter_arguments} );
	my $answer = $question->ask( $self->_files );

	return $self->_print_answer($answer);
}

=head2 _files (	)

=cut

sub _files {
	my ($self) = @_;
	my @files;

	$self->{argv} = [ getcwd() ] unless @{ $self->{argv} };

	# use map?
	for my $arg ( @{ $self->{argv} } ) {

		# is it a file?
		if ( -f $arg ) {
			push @files, $arg;
			next;
		}

		# is it a directory?
		if ( -d $arg ) {
			push @files, PSA::Files::files($arg);
			next;
		}
		App::Perlanalyst::die "'$arg' is neither file nor directory";
	}
	return \@files;
}

=head2 _display_filename ($filename)

=cut

sub _display_filename {
	my ( $self, $filename ) = @_;

	# remove cwd from the file to make it shorter and readable
	my $cwd = getcwd();
	$filename =~ s{$cwd}{.};

	# colour it if called interactive so we don't get the ANSI sequences
	# if the results are piped
	return colored( $filename, 'bold blue' ) if is_interactive;
	return $filename;
}

sub _display_elements_for_file {
	my ( $self, $elements, $filename ) = @_;
	print $self->_display_filename($filename) . ':' . "\n";

	for my $element (@$elements) {
		print $element->stringify() . "\n";
	}
}

=head2 _ask_question ()

=cut

sub _ask_question {
	my ($self) = @_;

	my $question_class = $self->{question};
	my $arguments      = $self->{question_arguments};

	# preprend PSA::Question if it's not already there
	unless ( $question_class =~ m{^PSA::Question::} ) {
		$question_class = 'PSA::Question::' . $question_class;
	}

	# load the question's module
	use_module($question_class);

	# create instance and set its arguments
	my $question = $question_class->new();
	$question->set_arguments($arguments);

	return $question->ask( $self->_files() );
}

=head2 _print_answer ($answer)

=cut

sub _print_answer {
    my ($self, $answer )=@_;
 
 	return 1 unless $answer;
 	
	for my $filename ( sort keys %$answer ) {
		my $elements = $answer->{$filename};
		$self->_display_elements_for_file( $elements, $filename );
	}   
	return 1;
}
1;
