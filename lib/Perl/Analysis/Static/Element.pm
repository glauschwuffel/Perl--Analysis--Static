package Perl::Analysis::Static::Element;
# ABSTRACT: represents an element of a Perl document

use Moose;
use PPI::Node;

=attr from

The line this element starts on.

=attr to

The line this element ends on.

=attr ppi_node

The instance of PPI::Node this element originated from.

The analysis that created this element used L<PPI> to scan
the document and found some L<PPI::Node>s. Use this node
if the element isn't sufficient for some reason. This might
be the case if you want to do some L<PPI> magic with it
(maybe refactoring?).

=cut

has 'from' => ( is => 'rw', isa => 'Int' );
has 'to' => ( is => 'rw', isa => 'Int' );
has 'ppi_node' => ( is => 'rw', isa => 'PPI::Node' );

sub stringify {
    my ($self) = @_;
    
    die 'implement me';
}

1;
