package FBP::Choice;

use Mouse;

our $VERSION = '0.33';

extends 'FBP::ControlWithItems';

has selection => (
	is       => 'ro',
	isa      => 'Int',
	required => 1,
);

has OnChoice => (
	is       => 'ro',
	isa      => 'Str',
);

1;
