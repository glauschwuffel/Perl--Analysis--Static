perlanalyst – analyse your Perl documents (without running them)

Perlanalyst is a tool to analyse your Perl documents. This is done via
static analysis, e.g. the code is analysed without running it.

The most simple usage of this tool is to ask a question about the sources
and the tool tells you the answer.

Here are some basic usage examples to help get you started.

  # find all subroutine declarations, recursively process all Perl
  # files beneath directory
  perlanalyst --all Sub
  
  # the same, but show only the declaration of the subroutine "foo"
  perlanalyst --all Sub --filter Name --filter-argument foo

  # the same, but asked as a question
  perlanalyst --question Sub::Name --question-argument foo
  
  # the same, but look in another directory
  perlanalyst -q Sub::Name -Q foo ~/perl5/lib/perl5/Test
