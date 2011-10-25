package Perl::Analysis::Static::Element;

use Moose;

has 'from' => ( is => 'rw', isa => 'Int' );
has 'to' => ( is => 'rw', isa => 'Int' );

sub stringify {
    my ($self) = @_;
    
    die 'implement me';
}

=head1 AUTHOR

Gregor Goldbach, glauschwuffel@nomaden.org

=head1 COPYRIGHT & LICENSE

Copyright 2011 Gregor Goldbach

This program is free software; you can redistribute it and/or modify it
under the terms of the Artistic License v2.0.

=cut

1;
