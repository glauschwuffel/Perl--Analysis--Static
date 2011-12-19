package App::Perlanalyst;

# ABSTRACT: main package for the perlanalyst tool

=head1 DESCRIPTION

This package implements the class App::Perlanalyst which acts as
a driver for the application L<perlanalyst>.

If you want to see this module in action, read about L<perlanalyst>.
 
=cut

use strict;
use warnings;

use Cwd;
use English qw( -no_match_vars );    # Avoids regex performance penalty
use Getopt::Long;
use IO::Interactive qw(is_interactive);
use List::Util qw(sum);
use Module::Runtime qw(use_module);
use Term::ANSIColor qw(colored);
use Term::ProgressBar::Simple;

use Perl::Analysis::Static::Question;
use Perl::Analysis::Static::Document;
use Perl::Analysis::Static::Files;
use Perl::Analysis::Static::Questioner;

our $VERSION   = '0.002';
our $COPYRIGHT = 'Copyright 2011 Gregor Goldbach.';

=head2 new

The C<new> constructor is quite trivial at this point, and is provided
merely as a convenience. You don't really need to think about this.

=cut

sub new {
    return bless {}, shift;
}

=method process_args (@args)

Processes the arguments with <Getopt::Long>. Results of the parsing
will be stuffed in the object's attributes. What's not an option is
stuffed in the C<argv> attribute for later procession.

=cut

sub process_args {
    my ( $self, @args ) = @_;

    # Getopt::Long processes ARGV
    local @ARGV = @args;
    Getopt::Long::Configure(qw(no_ignore_case bundling pass_through));

    GetOptions(
        'a|analysis|all=s' => \$self->{analysis},
        'f|filter=s'       => \@{ $self->{filter} },
        'h|help|?'         => \$self->{show_help},
        'man'              => sub {
            require Pod::Usage;
            Pod::Usage::pod2usage( { -verbose => 2 } );
            exit;
        },
        'q|question=s'           => \$self->{question},
        'Q|question-arguments=s' => \$self->{question_arguments},
        'v|verbose!'             => \$self->{verbose},
        'list-analyses!'         => \$self->{list_analyses},
        'list-filters!'          => \$self->{list_filters},
        'list-files!'            => \$self->{list_files},
        'list-questions!'        => \$self->{list_questions},
        'version'                => \$self->{show_version}
        )
        or App::Perlanalyst::die('Unable to parse options');

    # Stash the remainder of argv for later
    $self->{argv} = [@ARGV];
}

sub run {
    my ($self) = @_;

    # Show version or help?
    return show_version() if $self->{show_version};
    return show_help()    if $self->{show_help};

    # List what we can do
    return $self->_list_analyses()  if $self->{list_analyses};
    return $self->_list_filters()   if $self->{list_filters};
    return $self->_list_questions() if $self->{list_questions};
    return $self->_list_files()     if $self->{list_files};

    # There is neither an analysis or a question, so we'll give help
    return show_help() unless $self->{analysis} or $self->{question};

    # No, so we will ask a question. What files do we have?
    $self->{files} = $self->_files();

    # Setup or nice progress bar based on the file sizes.
    $self->_setup_progress_bar();

    # Just run an analysis if we're told to do so.
    return $self->analyse() if $self->{analysis};

    # No analysis wanted, shall we run a question?
    return $self->_ask_question() if $self->{question};

    # We should never get here. If we do, the logic above is strange
    # and we have a bug.
    _bug('Strange logic in run()');
}

=head2 die ($message)

Exits the program with the given message and a proper error
code for the shell.

=cut

# taken from App::Ack
sub die {
    my $program = File::Basename::basename($0);
    return CORE::die( $program, ': ', @_, "\n" );
}

=head2 _bug ($message)

This is an internal function that exits the program with
the given message and adds a phrase asking the user to report
this bug.

=cut

sub _bug {
    my ($message) = @_;
    $message .= '. This is a bug. Please report it so we can fix it.';
    &die($message);    # The ampersand calls the die() in this package.
}

sub analyse {
    my ($self) = @_;

    my $element_class = $self->{analysis};

    # preprend Perl::Analysis::Static::Element
    $element_class = 'Perl::Analysis::Static::Element::' . $element_class;

    my @filters;
    my @arguments;
    for my $filter ( @{ $self->{filter} } ) {

        # split filter and arguments
        my ( $f, $args ) = split( /=/, $filter );

        push @filters,   $f;
        push @arguments, $args;
    }

    my $question = Perl::Analysis::Static::Question->new(
        class     => $element_class,
        filter    => \@filters,
        arguments => \@arguments
    );

    return $self->_ask_and_print($question);
}

=head2 show_help()

Dumps the help page to the user.

=cut

sub show_help {
    print( <<"END_OF_HELP" );
Usage: perlanalyst [OPTION]... [FILES]...

Analyse your Perl documents in the tree from the current directory on down.
If [FILES] is specified, then only those files/directories are checked.

Examples: perlanalyst --all Sub

Analyses:
  --analysis            Specify what analysis to run.
  --list-analyses       List all analyses that may be run.
Filtering:
  --filter              Specify what filter to run on the list of elements found.
                        May be specified more than once.
                        Arguments to the filter may be given after an equal sign.
                        (e.g. --filter Name=foo)
  --list-filters        List all filters that may be used.

Questions:
  --question            Specify what question to ask.
                        Arguments to the question may be given after an equal sign.
                        (e.g. --question Sub::Name=foo)
  --list-questions      List all questions that may be called.

Files:
  --list-files			   List the files that would be examined.

Miscellaneous:
  --help                This help
  --man                 man page
  --version             Display version & copyright

This is version $VERSION of the perlanalyst.
END_OF_HELP
    return;
}

=head2 _setup_progress_bar (	)

=cut

sub _setup_progress_bar {
    my ($self) = @_;

    # we expect the time of an analyses to be a function of the
    # file's size
    my $total_size = sum map {-s} @{ $self->{files} };
    my $params = {
        name  => 'Files',
        count => $total_size
    };

    $self->{progress_bar} = Term::ProgressBar::Simple->new($params);
}

sub _increment_progress_bar {
    my ( $self, $file ) = @_;
    $self->{progress_bar}->increment( -s $file );
}

=head2 _files

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
            push @files, @{ Perl::Analysis::Static::Files::files($arg) };
            next;
        }
        App::Perlanalyst::die "'$arg' is neither file nor directory";
    }
    return \@files;
}

=head2 _display_filename ($filename)

=cut

sub _display_filename {
    my ($filename) = @_;

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

    # Don't display the filename if there are no elements.
    return unless $elements;

    print _display_filename($filename) . ':' . "\n";

    for my $element (@$elements) {
        print $element->stringify() . "\n";
    }
}

=head2 _ask_question ()

=cut

sub _ask_question {
    my ($self) = @_;

    my $q = $self->{question};
    my ( $question_class, $args ) = split( /=/, $q );

    # preprend Perl::Analysis::Static::Question
    $question_class = 'Perl::Analysis::Static::Question::' . $question_class;

    # load the question's module
    use_module($question_class);

    # create instance and set its arguments
    my $question = $question_class->new();
    $question->set_arguments($args);

    return $self->_ask_and_print($question);
}


sub _ask_and_print {
    my ($self, $question)=@_;

    # Ask the question for every file and store the answer.
    # Increment the progress bar after we got it.
    # This would be the perfect place to take the time.
    my $questioner = Perl::Analysis::Static::Questioner->new();

    my $collector =
        $questioner->ask_for_files( $question, $self->{files},
        sub { $self->_increment_progress_bar(shift) } );

    return $self->_print_answer($collector);
}

=head2 _print_answer ($collector)

=cut

sub _print_answer {
    my ( $self, $collector ) = @_;

    for my $filename ( sort $collector->filenames ) {
        my $answer = $collector->get_answer($filename);
        $self->_display_elements_for_file( $answer->elements, $filename );
    }

    return 1;
}

=head2 _list_modules ($kind, $name)


=cut

sub _list_modules {
    my ( $self, $kind, $name ) = @_;

    use_module('Perl::Analysis::Static::ModuleLister');
    my $lister=Perl::Analysis::Static::ModuleLister->new(kind=>$kind);
    my $modules=$lister->list();

    # the keys are the names, sort them for convenience
    my @result = sort @$modules;

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

sub _list_files {
    my ($self) = @_;
    my $files = $self->_files;
    my @display_names = map { _display_filename($_) } @$files;

    print "$_\n" for @display_names;
}

# stolen from App::Ack's get_version_statement

=head2 show_version

Returns the version information for perlanalyst.

=cut

sub show_version {
    require Config;

    my $this_perl = $Config::Config{perlpath};
    if ( $^O ne 'VMS' ) {
        my $ext = $Config::Config{_exe};
        $this_perl .= $ext unless $this_perl =~ m/$ext$/i;
    }
    my $ver = sprintf( '%vd', $^V );

    print <<"END_OF_VERSION";
perlanalyst $VERSION
Running under Perl $ver at $this_perl

$COPYRIGHT

This program is free software; you can redistribute it and/or modify it
under the terms as the Perl 5 programming language system itself.
END_OF_VERSION
}

=head1 SEE ALSO

=over 4

=item L<perlanalyst> to see this module in action

=item L<Getopt::Long> for parsing command line arguments

=item L<IO::Interactive> to examine if your program runs interactively

=item L<Module::List> to list installed modules

=item L<Module::Runtime> to load modules at runtime

=item L<Term::ANSIColor> for bringing colour to your terminal

=item L<Term::ProgressBar::Simple> for drawing progress bars

=back

=cut

1;
