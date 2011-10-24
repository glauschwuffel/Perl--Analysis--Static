package Perl::Analysis::Static::Element;

use Moose;

has 'from' => ( is => 'rw', isa => 'Int' );
has 'to' => ( is => 'rw', isa => 'Int' );

sub stringify {
    my ($self) = @_;
    
    die 'implement me';
}

1;
