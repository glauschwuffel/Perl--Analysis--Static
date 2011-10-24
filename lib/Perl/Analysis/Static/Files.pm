package Perl::Analysis::Static::Files;

use Moose;
use English qw( -no_match_vars );    # Avoids regex performance penalty
use Carp;
use File::Next;

sub files {
	my ($dir) = @_;

	# yes, this might be overhead
	my $files = File::Next::files($dir);

	my @files;
	while ( defined( my $file = $files->() ) ) {
		
		push @files, $file if _is_perl_file($file);
	}
	return @files;
}

sub _is_perl_file {
	my ($file)=@_;
	return 1 if $file =~m{\.t$};
	return 1 if $file =~m{\.pl$};
	return 1 if $file =~m{\.pm$};
	# TODO: check if shebang line is some perl invocation
	return;
}

return 1;