package FBP::CheckBox;

use Mouse;

our $VERSION = '0.17';

extends 'FBP::Control';

has label => (
	is  => 'ro',
	isa => 'Str',
);

has OnCheckBox => (
	is  => 'ro',
	isa => 'Str',
);

1;
