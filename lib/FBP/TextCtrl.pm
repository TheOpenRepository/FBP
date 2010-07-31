package FBP::TextCtrl;

use Mouse;

our $VERSION = '0.13';

extends 'FBP::Window';
with    'FBP::Control';





######################################################################
# Properties

has value => (
	is       => 'ro',
	isa      => 'Str',
	required => 1,
	default  => '',
);

has style => (
	is  => 'ro',
	isa => 'Str',
);

has maxlength => (
	is  => 'ro',
	isa => 'Int',
);





######################################################################
# Events

has OnText => (
	is  => 'ro',
	isa => 'Str',
);

has OnTextEnter => (
	is  => 'ro',
	isa => 'Str',
);

has OnTextURL => (
	is  => 'ro',
	isa => 'Str',
);

has OnTextMaxLen => (
	is  => 'ro',
	isa => 'Str',
);

1;