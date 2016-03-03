use Module::Build;

my $build = Module::Build->new(
	module_name => 'My::Protein',
	license     => 'perl',
	dist_author => 'Ian Sillitoe <i.sillitoe@ucl.ac.uk>',
	dist_abstract => 'Example modules to parse and manipulate proteins, domains, segments',
	requires    => {
		'Moose'                    => '2.16',
		'MooseX::Params::Validate' => '0.16'
	},
);

$build->create_build_script;

