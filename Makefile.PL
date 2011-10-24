use ExtUtils::MakeMaker;

WriteMakefile(
    NAME      => 'PSA',
    VERSION   => '0.002',
    ABSTRACT  => 'Static analysis of Perl documents',
    AUTHOR    => 'Gregor Goldbach <ggoldbach@cpan.org>',
    PREREQ_PM => {
        'Moose'           => 0,
        'PPI'             => 0,
        'Module::Runtime' => 0,
        'Getopt::Long'    => 0,
        'IO::Interactive' => 0,
        'Term::ANSIColor' => 0

    },
    EXE_FILES    => ['scripts/perlanalyst'],
    LICENSE      => 'perl',
    PREREQ_FATAL => 1
);
