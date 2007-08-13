package Dir::Self;

use 5.005;
use strict;

use File::Spec ();

*VERSION = \'0.02';

sub _croak {
	require Carp;
	local $^W = 0;
	*_croak = \&Carp::croak;
	goto &Carp::croak;
}

sub __DIR__ () {
	my $level = shift || 0;
	my $file = (caller $level)[1];
	File::Spec->rel2abs((File::Spec->splitpath($file))[1])
}

sub _const {
	my $value = shift;
	sub () { $value }
}

sub import {
	my $class = shift;
	my $caller = caller;

	for my $item (@_) {
		$item eq '__DIR__' or _croak qq{"$item" is not exported by the $class module};
	}

	no strict 'refs';
	*{$caller . "::__DIR__"} = _const &__DIR__(1);
}

1
__END__

=head1 NAME

Dir::Self - a __DIR__ constant for the directory your source file is in

=head1 SYNOPSIS

  use Dir::Self;
  
  use lib __DIR__ . "/lib";
  
  my $conffile = __DIR__ . "/config";

=head1 DESCRIPTION

Perl has two pseudo-constants describing the current location in your source
code, C<__FILE__> and C<__LINE__>. This module adds C<__DIR__>, which expands
to the directory your source file is in, as an absolute pathname.

This is useful if your code wants to access files in the same directory, like
helper modules or configuration data. This is a bit like L<FindBin> except
it's not limited to the main program, i.e. you can also use it in modules. And
it actually works.

=head1 BUGS

This module cheats. It generates a C<__DIR__> constant when it is C<use>d; any
subsequent uses of this C<__DIR__> won't pay attention to the actual source
location. So if you have two source files with the same C<package> declaration
in different directories, and one of them uses L<Dir::Self>, and the other
calls __DIR__, it will get the location of the C<use>, i.e. the first file.

This is unlikely to be a problem because normally each library file gets its
own package; but you can always use Dir::Self::__DIR__, which recomputes the
directory name each time it's called.

=head1 AUTHOR

Lukas Mai, E<lt>l.mai @web.deE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2007 by Lukas Mai

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.8.8 or,
at your option, any later version of Perl 5 you may have available.

=cut
