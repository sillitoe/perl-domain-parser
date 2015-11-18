package My::Utils;

use My::Protein;
use My::Domain;
use My::Segment;
use Path::Class;
use Carp qw/ croak /;

sub parse_gene3d_csv_file {
  my $csv_file = shift
    or croak "! Error: expected filename as argument";

  my $csv_fh = file( $csv_file )->open
    or die "! Error: failed to open file '$csv_file'";

  my %domains_by_md5;
  my @domains;
  my @md5s;

  while ( my $line = $csv_fh->getline ) {
    # 36e7577f574fa4ff9eeef861a9186178,3.90.70.10.FF16963,57:453,1,VSTDSTPVTNQKSSGRCWLFAATNQLRLNVLSELNLKEFELSQAYLFFYDKLEKANYFLDQIVSSADQDIDSRLVQYLLAAPTEDGGQYSMFLNLVKKYGLIPKDLYGDLPYSTTASRKWNSLLTTKLREFAETLRTALKERSADDSIIVTLREQMQREIFRLMSLFMDIPPVQPNEQFTWEYVDKDKKIHTIKSTPLEFASKYAKLDPSTPVSLINDPRHPYGKLIKIDRLGNVLGGDAVIYLNVDNETLSKLVVKRLQNNKAVFFGSHTPKFMDKKTGVMDIELWNYPAIGYNLPQQKASRIRYHESLMTHAMLITGCHVDETSKLPLRYRVENSWGKDSGKDGLYVMTQKYFEEYCFQIVVDINELPKELASKFTSGKEEPIVLPIWDPMGALA
    next if $line =~ /^#/;
    my @columns = split( ',', $line );

    die "! Error: expected 5 columns, found ".scalar(@columns)." (line: $., LINE: $line)"
      if scalar(@columns) != 5;

    my( $md5, $match_id, $regions, $not_sure, $sequence ) = @columns;

    # make sure we can get the superfamily id from the match id
    if ( $match_id !~ /^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+)/ ) {
      die "! Error: failed to get superfamily id from match id '$match_id' (line: $., LINE: $line)";
    }
    my $superfamily_id = $1;

    my $domain = My::Domain->new( domain_id => $superfamily_id );

    my @segment_start_stops = split( ':', $regions );
    my @segments;
    while ( scalar @segment_start_stops > 0 ) {
      my ($start, $stop) = splice( @segment_start_stops, 0, 2 );
      my $segment = My::Segment->new(
        domain_id => $superfamily_id,
        uni_start => $start,
        uni_stop  => $stop,
      );
      $domain->add_segment( $segment );
    }

    if ( ! exists $domains_by_md5{ $md5 } ) {
      push @md5s, $md5;
      $domains_by_md5{ $md5 } = [];
    }

    push @{ $domains_by_md5{ $md5 } }, $domain;
  }

  my @proteins;
  for my $md5 ( @md5s ) {

    my $protein = My::Protein->new( md5 => $md5 );

    for my $domain ( @{ $domains_by_md5{ $md5 } } ) {
      $protein->add_domain( $domain );
    }

    push @proteins, $protein;
  }

  return \@proteins;
}

1;
