#!/usr/bin/perl

use strict;
BEGIN {
	$|  = 1;
	$^W = 1;
}

use Test::More tests => 86;
use Test::NoWarnings;
use File::Spec::Functions ':ALL';
use FBP ();

my $FILE = catfile( 't', 'data', 'simple.fbp' );
ok( -f $FILE, "Found test file '$FILE'" );





######################################################################
# Simple Tests

# Create the empty object
my $object = FBP->new;
isa_ok( $object, 'FBP' );

# Parse the file
my $ok = eval {
	$object->parse_file( $FILE );
};
is( $@, '', "Parsed '$FILE' without error" );
ok( $ok, '->parse_file returned true' );

# Check the project properties
my $project = $object->find_first( isa => 'FBP::Project' );
isa_ok( $project, 'FBP::Project' );
is( $project->internationalize, '1', '->internationalize ok' );

# Find a particular named dialog
my $dialog1 = $object->dialog('MyDialog1');
isa_ok( $dialog1, 'FBP::Dialog' );
is( $dialog1->name,     'MyDialog1',  '->name ok'     );
is( $dialog1->subclass, '',           '->subclass ok' );
is( $dialog1->wxclass,  'Wx::Dialog', '->class ok'    );

# Repeat using the generic search
my $dialog2 = $object->find_first(
	isa  => 'FBP::Dialog',
	name => 'MyDialog1',
);
isa_ok( $dialog2, 'FBP::Dialog' );
is(
	$object->find_first( name => 'does_not_exists' ),
	undef,
	'->find_first(bad) returns undef',
);

# The search should work as well from children of the main object as well
my $dialog3 = $project->find_first( isa => 'FBP::Dialog' );
isa_ok( $dialog3, 'FBP::Dialog' );

# Multiple-search query equivalent
my @dialog4 = $project->find( isa => 'FBP::Dialog' );
is( scalar(@dialog4), 1, '->find(single) ok' );
isa_ok( $dialog4[0], 'FBP::Dialog' );

# Multiple-search query with multiple results
my @window = $project->find( isa => 'FBP::Window' );
is( scalar(@window), 23, '->find(multiple) ok' );
foreach ( @window ) {
	isa_ok( $_, 'FBP::Window' );
}

# Text properties
my $text = $object->find_first(
	isa => 'FBP::StaticText',
);
isa_ok( $text, 'FBP::StaticText' );
is( $text->id,         'wxID_ANY',       '->id ok'         );
is( $text->name,       'm_staticText1',  '->name ok'       );
is( $text->permission, 'protected',      '->permission ok' );
is( $text->subclass,   'My::Class;',     '->subclass ok'   );
is( $text->wxclass,    'My::Class',      '->class ok'      );
is(
	$text->label,
	'Michael "Killer" O\'Reilly <michael@localhost>',
	'->label ok',
);

# Button properties
my $button = $object->find_first(
	isa => 'FBP::Button',
);
isa_ok( $button, 'FBP::Button' );
is( $button->id,            'wxID_ANY',   '->id ok'            );
is( $button->name,          'm_button1',  '->name ok'          );
is( $button->label,         'MyButton',   '->label ok'         );
is( $button->default,       '1',          '->default ok'       );
is( $button->subclass,      '',           '->subclass ok'      );
is( $button->wxclass,       'Wx::Button', '->wxclass ok'       );
is( $button->permission,    'protected',  '->permission ok'    );
is( $button->OnButtonClick, 'm_button1',  '->OnButtonClick ok' );

# Combo properties
my $combo = $object->find_first(
	isa => 'FBP::ComboBox',
);
isa_ok( $combo, 'FBP::ComboBox' );
is( $combo->id,      'wxID_ANY',    '->id ok'    );
is( $combo->name,    'm_comboBox1', '->name ok'  );
is( $combo->value,   'Combo!',      '->value ok' );
is(
	$combo->choices,
	'"one" "two" "a\'b" "c\\"d \\\\\\""',
	'->choices ok',
);
is( scalar($combo->items), 4, 'Scalar ->items ok' );
is_deeply(
	[ $combo->items ],
	[ 'one', 'two', "a'b", 'c"d \\"' ],
	'->items ok',
);

# Line properties
my $line = $object->find_first(
	isa => 'FBP::StaticLine',
);
isa_ok( $line, 'FBP::StaticLine' );
is( $line->id,           'wxID_ANY',                    '->id ok'           );
is( $line->name,         'm_staticline1',               '->name ok'         );
is( $line->enabled,      '1',                           '->enabled ok'      );
is( $line->pos,          '',                            '->pos ok'          );
is( $line->size,         '',                            '->size ok'         );
is( $line->style,        'wxLI_HORIZONTAL',             '->style ok'        );
is( $line->window_style, 'wxNO_BORDER',                 '->window_style ok' );
is( $line->styles,       'wxLI_HORIZONTAL|wxNO_BORDER', '->styles ok'       );

# Sizer properties
my $sizer = $object->find_first(
	isa => 'FBP::Sizer',
);
isa_ok( $sizer, 'FBP::Sizer' );
is( $sizer->name,       'bSizer1',      '->name ok'       );
is( $sizer->orient,     'wxHORIZONTAL', '->orient ok'     );
is( $sizer->permission, 'none',         '->permission ok' );

# Listbook properties
my $listbook = $object->find_first(
	isa => 'FBP::Listbook',
);
isa_ok( $listbook, 'FBP::Listbook' );
is( $listbook->style, 'wxLB_DEFAULT', '->style ok' );

# SplitterWindow properties
my $splitterwindow = $object->find_first(
	isa => 'FBP::SplitterWindow',
);
isa_ok( $splitterwindow, 'FBP::SplitterWindow' );
is( $splitterwindow->style, 'wxSP_3D', '->style ok' );
is( $splitterwindow->splitmode, 'wxSPLIT_VERTICAL', '->splitmode ok' );
is( $splitterwindow->sashpos, '0', '->sashpos ok' );
is( $splitterwindow->sashsize, '-1', '->sashsize ok' );
is( $splitterwindow->sashgravity, '0.0', '->sashgravity ok' );
is( $splitterwindow->min_pane_size, '0', '->min_pane_size ok' );

# SplitterItem properties
my $splitteritem = $object->find_first(
	isa => 'FBP::SplitterItem',
);
isa_ok( $splitteritem, 'FBP::SplitterItem' );
