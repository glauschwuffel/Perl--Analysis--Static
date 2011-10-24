use ExtUtils::MakeMaker;

WriteMakefile(
    NAME      => 'Perl::Analysis::Static',
    VERSION   => '0.002',
    ABSTRACT  => 'Static analysis of Perl documents',
    AUTHOR    => 'Gregor Goldbach <glauschwuffel@nomaden.org>',
    PREREQ_PM => {
        'Moose'           => 0,
	'File::Next'      => 0,
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
