use 5.006;
use ExtUtils::MakeMaker;

WriteMakefile(
    'NAME'		=> 'Chemistry::File::Index',
    'VERSION_FROM'	=> 'Index.pm', 
    'PREREQ_PM'		=> {
        'Chemistry::Mol'        => '0.33',
    },
);
