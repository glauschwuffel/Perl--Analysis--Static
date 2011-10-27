package Perl::Analysis::Static;
# ABSTRACT: analyse your Perl documents (without running them)

our $VERSION=0.002;

=head1 DESCRIPTION

Perl::Analysis::Static extracts information from your Perl
sources. It's a toolbox for developers to take a look at their
code. It examines the code without running it.

Perl is notoriously hard to parse and flexible. Thus, programs
(and sometimes humans) have a hard time telling where variables
are declared, subroutines are called and if they are used at all.
The tools in this distribution hope to give humans and programs
the means to get answers for questions about perl code.

Humans may use the L<perlanalyst> on the command line whilst
machines ought to use the API provided by
L<Perl::Analysis::Static::Question> and friends.

=head1 WARNING

This is alpha software. This means that everything may change
any time. Programs, Modules and variables might be renamed, APIs
may be created or deleted.

=head1 A WORD ABOUT WORDS

The wonderful L<PPI>, which we use for parsing sources, introduced
the concept of a Perl document. We'll stick with that terminology.

=head1 SEE ALSO

L<PPI> is used for parsing the Perl documents.

L<Perl::Critic> is a different kind of tool. It has the knowledge
of experienced perl programmers built in and tells you if your
code smells.

=cut

1;
