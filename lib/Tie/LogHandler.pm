package Tie::LogHandler;

use strict;
use warnings;

our $VERSION = '0.1';

use Log::Handler;
use Data::Dumper;

sub TIEHANDLE {
	my $class = shift @_;
	my $self;
	($self->{log}, $self->{level}) = @_;
	unless ($self->{log}) {
		die "Got undef where Log::Handler object expected";
	}
	if (ref $self->{log} ne 'Log::Handler') {
		die "Argument passed is not a Log::Handler object";
	}
	$self->{level} ||= 'info';
	bless ($self, $class);
	return $self;
}

sub PRINT {
	my $self = shift @_;
	my $log = $self->{log};
	my $level = $self->{level};
	$log->$level(@_);
}

1;

__END__

=head1 NAME

Tie::Log::Handler - Tie a filehandle to L<Log::Handler>

=head1 SYNOPSIS

use Tie::LogHandler;

tie *STDOUT, 'Tie::LogHandler', $log, $level;

# this will be logged to the $log object passed at $level
warn "Darn, an error!";

=head1 DESCRIPTION

The following arguments are to be passed after the class name: a Log::Handler
object created with Log::Handler->new() and containing at least a log target; 
the loglevel to record messages at.

=head1 BUGS

This module does not safeguard against tying the same file handle that one
logs to. You should be careful and avoid this.

