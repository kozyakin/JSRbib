use strict;
use warnings;
use File::Slurp;

my $filecss = $ARGV[0];
my $filehtml = $ARGV[1];

my $html = read_file($filehtml);
my $css = read_file($filecss);

my $spattern = qr{<link .*href='$filecss'.*>};
my $rpattern = "<style type='text/css'>\n\n<!--\n$css\n\n-->\n</style>";

my $injectedHtml = $html =~ s/$spattern/$rpattern/r;

if ($injectedHtml) { 
    write_file($filehtml, $injectedHtml);
    print "\n\033[94mInject-CSS: done!\033[0m\n";
} else {
    print "\n\033[91mInject-CSS: Sorry! Something went wrong!\033[0m\n";
}

