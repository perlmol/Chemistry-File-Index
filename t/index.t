use Test::More;

plan 'no_plan';

use Chemistry::File::Index;
use Chemistry::File::SDF;

my $file = Chemistry::Mol->file('index.txt', format => 'index');

isa_ok( $file,  'Chemistry::File' );

$file->open('<');

my $mol = $file->read_mol($file->fh);
isa_ok( $mol,  'Chemistry::Mol' );
is ($mol->attr('sdf/data')->{MOLNAME}, 'AW 00005', 'molname');

$mol = $file->read_mol($file->fh, key => 'AW 00051');
is ($mol->attr('sdf/data')->{MOLNAME}, 'AW 00051', 'molname');

