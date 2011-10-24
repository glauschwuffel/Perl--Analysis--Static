package Perl::Analysis::Static::Filter::Name;

use Moose;

extends 'Perl::Analysis::Static::Filter';

has 'name' => ( is => 'rw', isa => 'Str' );

sub _filter {
    my ($self, $element) = @_;
    
    return 1 if $self->name() eq $element->name();
}

sub _set_arguments {
    my ($self, $arguments) = @_;

	$self->name($arguments->[0]);    
}

1;
