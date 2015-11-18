package My::Domain;

use Moose;
use My::Segment;

has domain_id => (
  is => 'ro',
  isa => 'Str',
);

has superfamily_id => (
  is => 'ro',
  isa => 'Str',
);

has sequence => (
  is => 'ro',
  isa => 'Str',
);

has md5 => (
  is => 'ro',
  isa => 'Str',
);

has segments => (
  traits => ['Array'],
  is     => 'ro',
  isa    => 'ArrayRef[My::Segment]',
  handles => {
    add_segment    => 'push',
    get_segment    => 'get',
    list_segments  => 'elements',
    count_segments => 'count',
  },
  default => sub { [] },
);

sub largest_segment {
  my $self = shift;
  my ($first_segment) = sort { $b->sequence_length <=> $a->sequence_length } $self->list_segments;
  return $first_segment;
}

__PACKAGE__->meta->make_immutable;
1;
