package Perl::Analysis::Static::Filter::StringLike;
# ABSTRACT: Does the string match this regex?

use Moose;

extends 'Perl::Analysis::Static::Filter';

has 'string' => ( is => 'rw', isa => 'Str' );

sub _filter {
    my ($self, $element) = @_;
    
    return 1 if $element->string() =~ $self->string();
}

sub _set_arguments {
    my ($self, $arguments) = @_;

	$self->string($arguments->[0]);    
}

1;
