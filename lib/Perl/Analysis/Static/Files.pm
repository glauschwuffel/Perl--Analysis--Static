package Perl::Analysis::Static::Files;

# ABSTRACT: tools for files

use Moose;
use English qw( -no_match_vars );    # Avoids regex performance penalty
use Carp;
use File::Next;

# stolen from ack, added .build
our %ignore_dirs = (
    '.bzr'           => 'Bazaar',
    '.cdv'           => 'Codeville',
    '~.dep'          => 'Interface Builder',
    '~.dot'          => 'Interface Builder',
    '~.nib'          => 'Interface Builder',
    '~.plst'         => 'Interface Builder',
    '.git'           => 'Git',
    '.hg'            => 'Mercurial',
    '.pc'            => 'quilt',
    '.svn'           => 'Subversion',
    '.build'         => 'Dist::Zilla',
    blib             => 'Perl module building',
    CVS              => 'CVS',
    RCS              => 'RCS',
    SCCS             => 'SCCS',
    _darcs           => 'darcs',
    _sgbak           => 'Vault/Fortress',
    'autom4te.cache' => 'autoconf',
    'cover_db'       => 'Devel::Cover',
    _build           => 'Module::Build',
);

# stolen from ack
sub ignoredir_filter {
    return !exists $ignore_dirs{$_};
}

sub files {
    my ($dir) = @_;

    my $descend_filter = sub { $_ !~ /^\.$/ };

    # yes, this might be overhead since we don't use the iterator.
    # meybe we'll use it later or we might just use File::Find
    my $files =
      File::Next::files( { descend_filter => \&ignoredir_filter }, $dir );

    my @files;
    while ( defined( my $file = $files->() ) ) {
        push @files, $file if _is_perl_file($file);
    }
    return \@files;
}

sub _is_perl_file {
    my ($file) = @_;
    return 1 if $file =~ m{\.t$};
    return 1 if $file =~ m{\.pl$};
    return 1 if $file =~ m{\.pm$};

    # TODO: check if shebang line is some perl invocation
    return;
}

1;
