package App::Perlanalyst;

use strict;
use warnings;

use Cwd;
use English qw( -no_match_vars );    # Avoids regex performance penalty
use Getopt::Long;
use IO::Interactive qw(is_interactive);
use Module::Runtime qw(use_module);
use Module::List qw(list_modules);
use Term::ANSIColor qw(colored);

use Perl::Analysis::Static::Document;
use Perl::Analysis::Static::Question;
use Perl::Analysis::Static::Files;

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
            'a|analysis|all=s'       => \$self->{analysis},
            'f|filter=s'             => \@{ $self->{filter} },
            'F|filter-arguments=s'   => \@{ $self->{filter_arguments} },
            'h|help|?'               => \$self->{show_help},
            'q|question=s'           => \$self->{question},
            'Q|question-arguments=s' => \$self->{question_arguments},
            'v|verbose!'             => \$self->{verbose},
            'list-analyses!'         => \$self->{list_analyses},
            'list-filters!'   => \$self->{list_filters},
            'list-questions!' => \$self->{list_questions}
        ) or App::Perlanalyst::die('Unable to parse options');

        # Stash the remainder of argv for later
        $self->{argv} = [@ARGV];
    }
}

sub run {
    my ($self) = @_;

    return $self->_list_analyses() if $self->{list_analyses};
    return $self->_list_filters() if $self->{list_filters};
    return $self->_list_questions() if $self->{list_questions};

    if ( $self->{analysis} ) {
        return $self->analyse() if $self->{analysis};
    }

    # ask questions if specified
    if ( $self->{question} ) {
        my $answer = $self->_ask_question( $self->_files() );
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

    # preprend Perl::Analysis::Static::Element if it's not already there
    unless ( $element_class =~ m{^Perl::Analysis::Static::Element::} ) {
        $element_class = 'Perl::Analysis::Static::Element::' . $element_class;
    }

    my $question = Perl::Analysis::Static::Question->new();
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
            push @files, Perl::Analysis::Static::Files::files($arg);
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

    # preprend Perl::Analysis::Static::Question if it's not already there
    unless ( $question_class =~ m{^Perl::Analysis::Static::Question::} ) {
        $question_class =
            'Perl::Analysis::Static::Question::' . $question_class;
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
    my ( $self, $answer ) = @_;

    return 1 unless $answer;

    for my $filename ( sort keys %$answer ) {
        my $elements = $answer->{$filename};
        $self->_display_elements_for_file( $elements, $filename );
    }
    return 1;
}

=head2 _list_modules ($kind, $name)


=cut

sub _list_modules {
    my ( $self, $kind, $name ) = @_;

    # build the module stem for that kind of modules
    my $stem = 'Perl::Analysis::Static::' . $kind . '::';
    my $modules = list_modules( $stem, { list_modules => 1, recurse => 1 } );

    # the keys are the names, sort them for convenience
    my @modules = sort keys %$modules;

    # remove the stem so the name is readable
    my @result = map { $_ =~ s{$stem}{}; $_ } @modules;

    # print them with a simple loop
    print "These are the available $name:\n";
    for my $module (@result) {
        print $module. "\n";
    }

    return 1;
}

=head2 _list_filters ()


=cut

sub _list_filters {
    my ($self) = @_;

    return $self->_list_modules( 'Filter', 'filters' );
}

=head2 _list_analyses ()


=cut

sub _list_analyses {
    my ($self) = @_;

    return $self->_list_modules( 'Analysis', 'analyses' );
}

=head2 _list_questions ()


=cut

sub _list_questions {
    my ($self) = @_;

    return $self->_list_modules( 'Question', 'questions' );
}

1;
