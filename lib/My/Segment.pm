package My::Segment;

use Moose;

has domain_id => (
  is => 'ro',
  isa => 'Str',
);

has sequence => (
  is => 'ro',
  isa => 'Str',
);

has uni_start => (
  is => 'ro',
  isa => 'Num',
);

has uni_stop => (
  is => 'ro',
  isa => 'Num',
);

sub sequence_length {
    my $self = shift;
    return $self->uni_stop - $self->uni_start;
}

__PACKAGE__->meta->make_immutable;
1;
