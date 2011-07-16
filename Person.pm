package Person;

use Moose;
use Moose::Util::TypeConstraints;

subtype 'PositiveInt',
    as 'Int',
    where { $_ > 0 },
    message { "The number you provided, $_, was not a positive integer." };

coerce 'PositiveInt'
    => from 'Str'
        => via { $_ eq '' ? $_ : int($_) }
    => from 'Any'
        => via { $_ =~ m/^[0-9]+\.[0-9]+$/ ? int($_) : length("$_") };

subtype 'DefinedInt',
    as 'PositiveInt',
    where { defined($_) },
    message { "You did not provide a number" };

subtype 'Serializable',
    as 'Str',
    where { defined($_); },
    message { "Serializable element must be defined" };

coerce 'Serializable'
    => from 'Any'
        => via { "$_"; };

has 'name' => ( is      => 'rw', 
                isa     => 'Serializable',
                default => 'Anonymous', 
                coerce  => 1, ); 

has 'age' => ( is       => 'rw', 
               isa      => 'DefinedInt | PositiveInt', 
               required => 1,
               coerce   => 1, );

has 'favorite_author' => ( is   => 'rw',
                           isa  => 'Person',
                           lazy => 1, 
                           default => sub { return Person->new(('age' => 1,)) } );

1;
