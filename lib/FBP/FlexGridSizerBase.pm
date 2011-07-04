package FBP::FlexSizer;

use Mouse::Role;

our $VERSION = '0.33';

has vgap => (
	is       => 'ro',
	isa      => 'Int',
	required => 1,
);

has hgap => (
	is       => 'ro',
	isa      => 'Int',
	required => 1,
);

has growablerows => (
	is      => 'ro',
	isa     => 'Str',
	default => '',
);

has growablecols => (
	is      => 'ro',
	isa     => 'Str',
	default => '',
);

has flexible_direction => (
	is  => 'ro',
	isa => 'Str',
);

has non_flexible_grow_mode => (
	is  => 'ro',
	isa => 'Str',
);

1;
