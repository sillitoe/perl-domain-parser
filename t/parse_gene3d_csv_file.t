use Test::More;
use Test::Exception;

use warnings;
use strict;

use My::Utils;
use FindBin;
use Path::Class;
use My::Protein;

my $test_data_file = "$FindBin::Bin/test_data.csv";

ok( -e $test_data_file, 'test csv data file exists' );

my $proteins = My::Utils::parse_gene3d_csv_file( $test_data_file );

isa_ok( $proteins, 'ARRAY', 'parse_gene3d_csv_file()' );

is( scalar @$proteins, 7, 'found 7 unique proteins' );

my @got_data = map { { md5 => $_->md5, domains => $_->count_domains } } @$proteins;

my @expected_data = (
  { md5 => '36e7577f574fa4ff9eeef861a9186178', domains => 1 },
  { md5 => '5249a5fc81889aa16399bda7cb51b719', domains => 2 },
  { md5 => '3e6381485ce680b611eabf3503504b99', domains => 3 },
  { md5 => '9f1a249eee2911b7eafcbc26a9f0720d', domains => 1 },
  { md5 => 'ee77462d2726c385cc029afdfb8ac1de', domains => 1 },
  { md5 => '2aff319666761de0b2912ad68631145a', domains => 1 },
  { md5 => '66dc1e71d5fe59c48da99f97ad6529bd', domains => 1 },
);

is_deeply( \@got_data, \@expected_data, 'md5s map to correct number of domains' );

my $example_protein = $proteins->[2];

isa_ok( $example_protein, 'My::Protein' );

is( $example_protein->count_domains, 3, 'correct number of domains' );

my $example_domain = $example_protein->get_domain(1);

isa_ok( $example_domain, 'My::Domain' );

is( $example_domain->count_segments, 2, 'correct number of segments' );

is( $example_protein->to_mda_string( type => 'largest_segment' ), '3.30.930.10__3.30.930.10__3.40.50.800', 'mda string (based on largest segment) looks okay' );

throws_ok { My::Protein->new() } qr/required/, 'Protein requires MD5';

done_testing;
