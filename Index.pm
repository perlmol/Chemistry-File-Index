package Chemistry::File::Index;

$VERSION = '0.10';
# $Id$

use base qw(Chemistry::File);
use Chemistry::Mol;
use Carp;
use strict;
use warnings;
use Search::Dict qw(look);

=head1 NAME

Chemistry::File::Index - Index molecule format reader/writer

=head1 SYNOPSIS

    use Chemistry::File::Index;

    my $file = Chemistry::Mol->file('mols.idx', format => 'index');
    $file->read_header($file->fh);
    my $mol  = $file->read_mol($file->fh, id => 'NH 00042');
    my $next_mol = $file->read_mol($file->fh);         # read next mol

=cut

=head1 DESCRIPTION

This module reads index files. It automatically registers the 'index' format
with Chemistry::Mol, so that index files may be identified and read by
Chemistry::Mol->file().

An index file has the following format:

    id      file    pos     [format]
    id      file    pos     [format]

=cut

Chemistry::Mol->register_format(index => __PACKAGE__);

sub name_is {
    my ($class, $fname) = @_;
    $fname =~ /\.idx$/i;
}

sub file_is {
    my ($class, $fname) = @_;
    $fname =~ /\.idx$/i;
}

sub read_mol {
    my ($self, $fh, %opts) = @_;

    if ($opts{key}) {
        look($fh, $opts{key});
    }

    my @mols;
    while (my $line = <$fh>) {
        my ($key, $fname, $pos, $format) = split "\t", $line;

        return if ($opts{key} and $opts{key} ne $key);

        my $file = Chemistry::Mol->file($fname, format => $format);
        $file->open('<');
        $file->fh->seek($pos, 0) or croak "Seek error";
        my $mol = $file->read_mol($file->fh, format => $format);

        return $mol unless $opts{key} and wantarray;
        push @mols, $mol;
    }
    @mols;
}

1;

=head1 VERSION

0.10

=head1 SEE ALSO

L<Chemistry::File>, L<Chemistry::File::SDF>, L<http://www.perlmol.org/>.

=head1 AUTHOR

Ivan Tubert-Brohman <itub@cpan.org>

=cut

