package Perl::Analysis::Static::ModuleLister;
# ABSTRACT: list all module below a namespace

=head2 DESCRIPTION

=cut

use Moose;

use Module::List qw(list_modules);

has 'kind' => ( is => 'rw', isa => 'Str' );

=head2 list ($kind)

=cut

sub list {
    my ($self) = @_;

    # build the module stem for that kind of modules
    my $stem    = 'Perl::Analysis::Static::' . $self->kind . '::';
    my $modules = list_modules( $stem, { list_modules => 1, recurse => 1 } );

    # remove the stem so the name is readable
    my @result;
    for my $module (@$modules) {
        $module =~ s{$stem}{};
        push @result, $module;
    }
    return \@result;
}

1;
