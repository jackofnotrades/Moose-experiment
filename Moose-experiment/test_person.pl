#!/usr/bin/perl

#  code is data is code is data is ...

use strict;
use warnings;
use Test::More tests=>11;
use Person;

my ($pass, $fail, $name, @test_input, $person) =  (" passes validation", 
                                                   " fails validation",
                                                   'Name ',
                                                   '',
                                                   '',
                                                   '',
                                                   12,
                                                   ['',],
                                                   "1337h4x0R-11+1",
                                                   "typicalUser3",
                                                   "Joe Blow",
                                                   "Joe Blow, Jr.",
                                                   "Henry VIII",
                                                   "Brian O'Malley III");
my @test_output  =  (qr/Attribute \(age\) is required/,
                     'Anonymous',
                     'Anonymous',
                     qr/doesn\'t look like a proper name/,
                     qr/doesn\'t look like a proper name/,
                     qr/doesn\'t look like a proper name/,
                     qr/doesn\'t look like a proper name/,
                     qr/doesn\'t look like a proper name/,
                     qr/doesn\'t look like a proper name/,
                     qr/doesn\'t look like a proper name/,
                     qr/doesn\'t look like a proper name/);
my @messages     =  (["Empty age exception", $pass], 
                     [$name."default", $pass],
                     ["Author lazy loads", $pass],
                     [$name, $fail],
                     [$name, $fail],
                     [$name, $fail],
                     [$name, $fail],
                     [$name, $pass],
                     [$name, $pass],
                     [$name, $pass],
                     [$name, $pass]);
my @modifiers    =  (['NOOP',],
                     ['age', 12],
                     ['favorite_author->name',],
                     ['name',],
                     ['name',],
                     ['name',],
                     ['name',],
                     ['name', '!'],
                     ['name', '!'],
                     ['name', '!'],
                     ['name', '!']);
my @evals        =  (sub { return (eval {Person->new()});},
                     sub { my ($p, $i, $m) = @_; return (eval { $$p = Person->new("$m->[0]" => $m->[1]); }); },
                     sub { my ($p, $i, $m, $n) = @_; 
                           $m = $m->[0];  
                           ($m, $n) = split('->', $m) if($m =~ m/\-\>/); 
                           return (eval { defined($i) and $i ? defined($n) ? $$p->$m->$n($i) 
                                                                           : $$p->$m($i) 
                                                             : defined($n) ? $$p->$m->$n()
                                                                           : $$p->$m(); }); });
my $eval;
for my $input (@test_input) {
    my ($output, $message, $modifier)  =  (shift @test_output, shift @messages, shift @modifiers);
    undef $@;
    $eval  =  defined($evals[0]) ? shift @evals : $eval;
    $eval->(\$person, $input, $modifier);
    $message  =  $message->[0] . $input . $message->[1];
    if($@) {
        if(defined($modifier->[1]) and $modifier->[1] eq '!') {
            ok($@ !~ m/$output/, $message) or print $@;
        } else {
            ok($@ =~ m/$output/, $message) or print $@;
        }
    } else {
        pass($message);
    }
}
