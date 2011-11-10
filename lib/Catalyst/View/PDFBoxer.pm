package Catalyst::View::PDFBoxer;
use Moose::Role;

# ABSTRACT: Runs view output through PDF::Boxer and sets response content-type if not already set.

use PDF::Boxer 0.003;
use PDF::Boxer::SpecParser;

use namespace::clean -except => 'meta';

requires 'process';

before process => sub {
    my ($self, $c) = @_;
    unless ( $c->response->content_type ) {
        $c->response->content_type('application/pdf; charset=utf-8');
    }
};

after process => sub {
    my ($self, $c) = @_;
    my $spec = PDF::Boxer::SpecParser->new->parse($c->response->body);
    my $boxer = PDF::Boxer->new;
    $boxer->add_to_pdf($spec);
    $c->response->body($boxer->doc->pdf->stringify);
};

1;

__END__

=head1 SYNOPSIS

    package MyApp::View::PDFBoxer;

    use Moose;
    use namespace::clean -except => 'meta';

    extends qw/Catalyst::View::TT/;
    with qw/Catalyst::View::PDFBoxer/;

    1;

=head1 DESCRIPTION

This is a Role which takes the current $c->response->body, runs it through
PDF::Boxer as it's "spec" file to get a PDF::API2 object. $c->response->body
is then set to the stringified PDF and content-type is set accordingly.

=head1 METHOD MODIFIERS

=head2 before process

Sets content-type to 'application/pdf; charset=utf-8' if not already set.

=head2 after process

Takes the current $c->response->body, runs it through PDF::Boxer as it's "spec"
file to get a PDF::API2 object. $c->response->body is then set to the
stringified PDF.

=head1 SEE ALSO

=for :list
* L<PDF::Boxer> - PDF generator used by this role.

=cut




