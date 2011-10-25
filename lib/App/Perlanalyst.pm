package App::Perlanalyst;

=head1 NAME

App::Perlanalyst -- main package for the perlanalyst tool

=head1 DESCRIPTION

This package implements the class App::Perlanalyst which acts like
a driver for everything else.

=cut

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

our $VERSION='0.002';
our $COPYRIGHT='Copyright 2011 Gregor Goldbach.';

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
            'h|help|?'               => \$self->{show_help},
            'man'                    => sub {
                                          require Pod::Usage;
                                          Pod::Usage::pod2usage({-verbose => 2});
                                          exit;
                                        },
            'q|question=s'           => \$self->{question},
            'Q|question-arguments=s' => \$self->{question_arguments},
            'v|verbose!'             => \$self->{verbose},
            'list-analyses!'         => \$self->{list_analyses},
            'list-filters!'   => \$self->{list_filters},
            'list-questions!' => \$self->{list_questions},
            'version' => \$self->{show_version}
        ) or App::Perlanalyst::die('Unable to parse options');

        # Stash the remainder of argv for later
        $self->{argv} = [@ARGV];
    }
}

sub run {
    my ($self) = @_;

    return show_version() if $self->{show_version};
    return show_help() if $self->{show_help};

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
    return show_help();


}

# stolen from von App::Ack
sub die {
    my $program = File::Basename::basename($0);
    return CORE::die( $program, ': ', @_, "\n" );
}

sub analyse {
    my ($self) = @_;

    my $element_class = $self->{analysis};

    # preprend Perl::Analysis::Static::Element
    $element_class = 'Perl::Analysis::Static::Element::' . $element_class;

    my @filters;
    my @arguments;
    for my $filter (@{$self->{filter}}) {
        # split filter and arguments
        my ($f, $args)=split(/=/, $filter);

        push @filters, $f;
        push @arguments, $args;
    }

    my $question = Perl::Analysis::Static::Question->new(
      class => $element_class,
      filter => \@filters,
      arguments => \@arguments);
    my $answer = $question->ask( $self->_files );

    return $self->_print_answer($answer);
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

Miscellaneous:
  --help                This help
  --man                 man page
  --version             Display version & copyright

This is version $VERSION of the perlanalyst.
END_OF_HELP
    return;
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

    my $q = $self->{question};
    my ($question_class, $args)=split(/=/, $q);

    # preprend Perl::Analysis::Static::Question
    $question_class='Perl::Analysis::Static::Question::' . $question_class;

    # load the question's module
    use_module($question_class);

    # create instance and set its arguments
    my $question = $question_class->new();
    $question->set_arguments($args);

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

# stolen from App::Ack's get_version_statement
=head2 show_version

Returns the version information for perlanalyst.

=cut

sub show_version {
    require Config;

    my $copyright = $COPYRIGHT;
    my $this_perl = $Config::Config{perlpath};
    if ($^O ne 'VMS') {
        my $ext = $Config::Config{_exe};
        $this_perl .= $ext unless $this_perl =~ m/$ext$/i;
    }
    my $ver = sprintf( '%vd', $^V );

    print <<"END_OF_VERSION";
perlanalyst $VERSION
Running under Perl $ver at $this_perl

$copyright

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License v2.0.
END_OF_VERSION
}

=head1 AUTHOR

Gregor Goldbach, glauschwuffel@nomaden.org

=head1 COPYRIGHT & LICENSE

Copyright 2011 Gregor Goldbach

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License v2.0.

=cut

1;
