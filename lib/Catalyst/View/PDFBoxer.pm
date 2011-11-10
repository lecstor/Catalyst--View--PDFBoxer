package Catalyst::View::PDFBoxer;
use Moose;

extends 'Catalyst::View::TT';

use PDF::Boxer;
use PDF::Boxer::SpecParser;

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
