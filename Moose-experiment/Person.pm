package Person;

use Moose;
use Moose::Util::TypeConstraints;

my $int_pat              =  qr/^[0-9]+$/;
my $number_pat           =  qr/^$int_pat(\.$int_pat)?$/;
my $email_uname_pat      =  qr/^[a-zA-Z0-9_\!\#\$\%\'\*\+\-\/\=\?\^\`\{\}\|\~]+$/;             # <-- email username validation pattern
my $strict_uname_pat     =  qr/^[a-zA-Z][a-zA-Z0-9_\-\.]+$/;                                   # <-- more typical username restriction
my $strict_propname_pat  =  qr/^[A-Z][a-z\']+((\s*|\')?[a-zA-Z]+)*(\,?\s*?([IVX]+|([jsJS]r\.?)))?$/; # <-- typical Roman chars name validation?

subtype 'DefinedInt',
    as  'Int',
    where { defined($_) },
    message { "You did not provide a number" };

subtype 'PositiveInt',
    as  'DefinedInt',
    where { $_ =~ m/$int_pat/ and $_ > 0 },
    message { "The number you provided, $_, was not a positive integer." };

coerce 'PositiveInt'
    => from 'Str'
        => via { $_ =~ m/$number_pat/ ? int($_) : length("$_") }
    => from 'Any'
        => via { length("$_") };

subtype 'Serializable',
    as  'Any',
    where { defined($_); },
    message { "Serializable element must be defined" };

coerce 'Serializable'
    => from 'Any'
        => via { "$_"; };

subtype 'EName',
    as  'Serializable',
    where { $_ =~ m/$email_uname_pat/; },
    message { "$_ doesn't look like an email username to me"  };

subtype 'UName',
    as  'Serializable',
    where { $_ =~ m/$strict_uname_pat/; },
    message { "$_ doesn't look like a username to me" };

subtype 'PName',
    as 'Serializable',
    where { $_ =~ m/$strict_propname_pat/; },
    message { "$_ doesn't look like a proper name in the Roman character set" };

has 'name' => ( is      => 'rw', 
                isa     => 'PName',
                default => 'Anonymous', );

has 'age' => ( is       => 'rw', 
               isa      => 'PositiveInt', 
               required => 1,
               coerce   => 1, );

has 'favorite_author' => ( is   => 'rw',
                           isa  => 'Person',
                           lazy => 1, 
                           default => sub { return Person->new(('age' => 1,)) } );

no Moose;
__PACKAGE__->meta->make_immutable;
1;
