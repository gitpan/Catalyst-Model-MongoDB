package Catalyst::Model::MongoDB;
use base qw/Catalyst::Model/;
use strict;
use warnings;

use NEXT;
use Carp qw(confess);
use MongoDB;

our $VERSION = '0.02';

sub new {
    my ($class, $c, $config) = @_;
    my $self = $class->NEXT::new($c, $config);
    $self->config($config);

    my $conf = $self->config;
    $self->{mongodb_connection} = MongoDB::Connection->new($conf);
    $c->log->debug("MongoDB::Connection instantiated") if $c->debug;

    return $self;
}

sub AUTOLOAD {
    my ($self, @args) = @_;
    our $AUTOLOAD;
    return if $AUTOLOAD =~ /::DESTROY$/;

    (my $meth = $AUTOLOAD) =~ s/^.*:://;

    return $self->{mongodb_connection}->$meth(@args);
}


1;

=pod

=head1 NAME

Catalyst::Model::MongoDB - MongoDB model class for Catalyst

=head1 SYNOPSIS

    # model
    __PACKAGE__->config(
 		host => 'localhost',
		port => 27017,       
    );

    # controller
    sub foo : Local {
        my ($self, $c) = @_;

        eval {
            my @docs = $c->model('MyData')->mydatabase->mycollection->find();
        };
        ...
    }


=head1 DESCRIPTION

This model class exposes L<MongoDB::Connection> as a Catalyst model.

=head1 CONFIGURATION

You can pass the same configuration fields as when you make a new L<MongoDB::Connection>.

=head1 METHODS

=head2 MongoDB

All the methods not handled locally are forwarded to L<MongoDB::Connection>.

=head2 new

Called from Catalyst.

=head1 AUTHOR

Torsten Raudssus <torsten@raudssus.de>

=head1 BUGS 

Please report any bugs or feature requests to me on IRC Getty at irc.perl.org, or make a pull request
at http://github.com/Getty/catalyst-model-mongodb

=head1 COPYRIGHT & LICENSE 

Copyright 2010 Torsten Raudssus, all rights reserved.

This library is free software; you can redistribute it and/or modify it under the same terms as 
Perl itself, either Perl version 5.8.8 or, at your option, any later version of Perl 5 you may 
have available.

=cut
