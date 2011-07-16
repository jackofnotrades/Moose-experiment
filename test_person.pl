#!/usr/bin/perl

use strict;
use warnings;
use Test::More tests=>20;
use Test::Exception;
use Person;

my $person;

# throws an error if 'age' is empty
eval { $person = Person->new(); };
ok($@ =~ qr/Attribute \(age\) is required/, "Empty age exception");

# uses default name
$person = Person->new(('age' => 12));
ok($person->name() eq 'Anonymous', "Name default");
# favorite_author lazy-loads (and defaults to 'Anonymous')
ok($person->favorite_author->name() eq 'Anonymous', "Author lazy");

my $scalar   =  1;
my $val      =  \$scalar;
my $val_str  =  "$val";
$person->name($val);
ok($person->name() eq $val_str, "Coerce name from scalar ref");
$person->age($val);
ok($person->age() eq length($val_str), "Coerce age from scalar ref");
$val      =  { 'whocares' => 'nothing' };
$val_str  =  "$val";
$person->name($val);
ok($person->name() eq $val_str, "Coerce name from hash ref");
$person->age($val);
ok($person->age() eq length($val_str), "Coerce age from hash ref");
$val      =  \(1 .. 10);
$val_str  =  "$val";
$person->name($val);
ok($person->name() eq $val_str, "Coerce name from array ref");
$person->age($val);
ok($person->age() eq length($val_str), "Coerce age from array ref");
$val      =  sub { return };
$val_str  =  "$val";
$person->name($val);
ok($person->name() eq $val_str, "Coerce name from code ref");
$person->age($val);
ok($person->age() eq length($val_str), "Coerce age from code ref");
$val      =  qr/blah/;
$val_str  =  "$val";
$person->name($val);
ok($person->name() eq $val_str, "Coerce name from regexp ref");
$person->age($val);
ok($person->age() eq length($val_str), "Coerce age from regexp ref");
$val      =  \*STDOUT;
$val_str  =  "$val";
$person->name($val);
ok($person->name() eq $val_str, "Coerce name from glob ref");
$person->age($val);
ok($person->age() eq length($val_str), "Coerce age from glob ref");
$val      =  Person->new(('age' => 1));
$val_str  =  "$val";
$person->name($val);
ok($person->name() eq $val_str, "Coerce name from object");
$person->age($val);
ok($person->age() eq length($val_str), "Coerce age from object");
$val      =  255;
$val_str  =  "$val";
$person->name($val);
ok($person->name() eq $val_str, "Coerce name from integer");
$val      =  4.23;
$val_str  =  "$val";
$person->name($val);
ok($person->name() eq $val_str, "Coerce name from float");
$person->age($val);
ok($person->age() eq length($val_str), "Coerce age from float");
