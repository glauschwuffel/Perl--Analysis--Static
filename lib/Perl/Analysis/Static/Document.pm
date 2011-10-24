package Perl::Analysis::Static::Document;

use Moose;
use PPI;

use Module::Runtime qw(use_module);
    
has 'filename' => ( is => 'rw', isa => 'Str' );
has 'ppi' => (
    is      => 'rw',
    isa     => 'PPI::Document',
    lazy    => 1,
    builder => '_build_ppi'
);

=head2 find ($class)

Find all elements of a certain $class.

=cut

sub find {
    my ($self, $class) = @_;

    unless ($class =~ m{Perl::Analysis::Static::Element::(.+)}) {
        # we should do something else here
        die "BUG: Unable to match class '$class'";
    }
    my $element=$1;
    
    # get name of analysis
    my $analysis_class = 'Perl::Analysis::Static::Analysis::'.$element;

    use_module($analysis_class);
    
    # TODO
    my $analysis=$analysis_class->new();
    return $analysis->analyse($self);
}

=head1 INTERNAL METHODS

=head2 _build_ppi ()

Return PPI::Document of this document.

=cut

sub _build_ppi {
    my ($self) = @_;

    # content ought to be passed as reference
#    my $ppi = PPI::Document->new( \$self->source()->content() );
    my $ppi = PPI::Document->new( $self->filename );
	unless ($ppi) {
		die "Unable to create instance of '".$self->filename."'";
	}

    # we have to set the tab width and call index_locations or we won't get
    # correct information about the location (or maybe no location information
    # at all). I don't know if this is always the case or just a matter of
    # versioning.
    $ppi->tab_width(4);
    $ppi->index_locations() or die 'index';

    return $ppi;
}

1;
