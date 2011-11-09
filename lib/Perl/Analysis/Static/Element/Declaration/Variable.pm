package Perl::Analysis::Static::Element::Declaration::Variable;
# ABSTRACT: declaration of a variable

use Moose;

extends 'Perl::Analysis::Static::Element::Declaration';

has 'name' => ( is => 'rw', isa => 'Str' );

=head2 stringify ()

=cut

sub stringify {
    my ($self)=@_;
    
    return $self->from.': '.$self->name;
}

=head1 DESCRIPTION

This is a rather abstract class. You might want to use
L<Perl::Analysis::Static::Element::Declaration::Variable::Lexical>
or L<Perl::Analysis::Static::Element::Declaration::Variable::Package>.

=cut

1;
