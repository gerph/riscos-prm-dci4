#!/usr/bin/perl
##
# Generate a simple index for the PRMinXML staging repository.
# We're linking to each of the different styles of the documents.
#

use warnings;
use strict;

my $output = shift;
my $outputdir = shift;

# We need to determine the styles we can use
opendir(my $dh, $outputdir);
my @styles = grep { -f "$outputdir/$_/html/index.html" } readdir($dh);

my %style_names = (
        'prm-modern'    => 'Modern style',
        'prm'           => 'RISC OS 3 PRM style',
        'prm-ro2'       => 'RISC OS 2 PRM style',
        'regular'       => 'Simple style for browsers',
        'unstyled'      => 'Unstyled (no CSS)',
    );
my %style_weights = (
        'prm-modern'    => 0,
        'prm'           => 1,
        'prm-ro2'       => 2,
        'regular'       => 3,
        'unstyled'      => 4,
    );


sub read_file {
    my ($file) = @_;
    open(my $fh, '<', $file) || die "Cannot read '$file': $!\n";
    my $content = '';
    while (<$fh>) {
        $content .= $_;
    }
    close($fh);
    return $content;
}


my $head = read_file('index-head.html');
my $tail = read_file('index-tail.html');

my @rows;
for my $style (sort { ($style_weights{$a} // 10) <=> ($style_weights{$b}) } @styles) {
    my $title = $style_names{$style} // "(UNTITLED: $style)";
    my $pdffile = "$style/RISC_OS_PRM_Staging.pdf";

    my $row = "<li class='index-link'>";
    $row .= "<span class='index-title'><a href='$style/html/index.html'>$title</a></span>";
    if (-f "$outputdir/$pdffile") {
        $row .= " (<a href='$pdffile'>PDF</a>)";
    }
    $row .= "</li>";
    push @rows, "$row\n";
}

open(my $fh, '>', $output) || die "Cannot write output '$output': $!\n";
print $fh $head;
for my $row (@rows)
{
    print $fh $row;
}
print $fh $tail;
close($fh);
