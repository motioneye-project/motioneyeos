#!/usr/bin/perl -w
# vi: set ts=4:
# Copyright (c) 2001 David Schleef <ds@schleef.org>
# Copyright (c) 2001 Erik Andersen <andersen@codepoet.org>
# Copyright (c) 2001 Stuart Hughes <stuarth@lineo.com>
# Copyright (c) 2002 Steven J. Hill <shill@broadcom.com>
# This program is free software; you can redistribute it and/or modify it
# under the same terms as Perl itself.

# TODO -- use strict mode...
#use strict;

use Getopt::Long;
use File::Find;


# Set up some default values

my $basedir="";
my $kernel;
my $kernelsyms;
my $stdout=0;
my $verbose=0;


# get command-line options

my %opt;

GetOptions(
	\%opt,
	"help|h",
	"basedir|b=s" => \$basedir,
	"kernel|k=s" => \$kernel,
	"kernelsyms|F=s" => \$kernelsyms,
	"stdout|n" => \$stdout,
	"verbose|v" => \$verbose,
);

if (defined $opt{help}) {
	print
	"  $0 [OPTION]... [basedir]\n",
	"     -h --help\t\tShow this help screen\n",
	"     -b --basedir\tModules base directory (defaults to /lib/modules)\n",
	"     -k --kernel\tKernel binary for the target\n",
	"     -F --kernelsyms\tKernel symbol file\n",
	"     -n --stdout\tWrite to stdout instead of <basedir>/modules.dep\n",
	"     -v --verbose\tPrint out lots of debugging stuff\n",
	;
	exit 1;
}

if($basedir !~ m-/lib/modules-) {
    warn "WARNING: base directory does not match ..../lib/modules\n";
}

# Find the list of .o files living under $basedir
#if ($verbose) { printf "Locating all modules\n"; }
my($ofile) = "";
my($file) = "";
my(@liblist) = ();
find sub {
	if ( -f $_  && ! -d $_ ) {
		$file = $File::Find::name;
		if ( $file =~ /.o$/ ) {
			push(@liblist, $file);
			if ($verbose) { printf "$file\n"; }
		}
	}
}, $basedir;
if ($verbose) { printf "Finished locating modules\n"; }

foreach $obj ( @liblist, $kernel ){
    # turn the input file name into a target tag name
    # vmlinux is a special that is only used to resolve symbols
    if($obj =~ /vmlinux/) {
        $tgtname = "vmlinux";
    } else {
        ($tgtname) = $obj =~ m-(/lib/modules/.*)$-;
    }

    warn "MODULE = $tgtname\n" if $verbose;

    # get a list of symbols
	@output=`nm $obj`;
	$ksymtab=grep m/ __ksymtab/, @output;

    # gather the exported symbols
	if($ksymtab){
        # explicitly exported
        foreach ( @output ) {
            / __ksymtab_(.*)$/ and do {
                warn "sym = $1\n" if $verbose;
                $exp->{$1} = $tgtname;
            };
        }
	} else {
        # exporting all symbols
        foreach ( @output) {
            / [ABCDGRST] (.*)$/ and do {
                warn "syma = $1\n" if $verbose;
                $exp->{$1} = $tgtname;
            };
        }
	}
    # gather the unresolved symbols
    foreach ( @output ) {
        !/ __this_module/ && / U (.*)$/ and do {
            warn "und = $1\n" if $verbose;
            push @{$dep->{$tgtname}}, $1;
        };
    }
}


# reduce dependancies: remove unresolvable and resolved from vmlinux
# remove duplicates
foreach $module (keys %$dep) {
    $mod->{$module} = {};
    foreach (@{$dep->{$module}}) {
        if( $exp->{$_} ) {
            warn "resolved symbol $_ in file $exp->{$_}\n" if $verbose;
            next if $exp->{$_} =~ /vmlinux/;
            $mod->{$module}{$exp->{$_}} = 1;
        } else {
            warn "unresolved symbol $_ in file $module\n";
        }
    }
}

# resolve the dependancies for each module
if ($stdout == 1) {
	foreach $module ( keys %$mod ) {
		print "$module:\t";
		@sorted = sort bydep keys %{$mod->{$module}};
		print join(" \\\n\t",@sorted);
		print "\n\n";
	}
} else {
	open(OFILE, ">$basedir/modules.dep");
	foreach $module ( keys %$mod ) {
		print OFILE "$module:\t";
		@sorted = sort bydep keys %{$mod->{$module}};
		print OFILE join(" \\\n\t",@sorted);
		print OFILE "\n\n";
	}
}


sub bydep
{
    foreach my $f ( keys %{$mod->{$b}} ) {
        if($f eq $a) {
            return 1;
        }
    }
    return -1;
}



__END__

=head1 NAME

depmod.pl - a cross platform script to generate kernel module dependency
		lists which can then be used by modprobe.

=head1 SYNOPSIS

depmod.pl [OPTION]... [basedir]...

Example:

	depmod.pl -F linux/System.map target/lib/modules

=head1 DESCRIPTION

The purpose of this script is to automagically generate a list of of kernel
module dependancies.  This script produces dependancy lists that should be
identical to the depmod program from the modutils package.  Unlike the depmod
binary, however, depmod.pl is designed to be run on your host system, not
on your target system.

This script was written by David Schleef <ds@schleef.org> to be used in
conjunction with the BusyBox modprobe applet.

=head1 OPTIONS

=over 4

=item B<-h --help>

This displays the help message.

=item B<-b --basedir>

The base directory uner which the target's modules will be found.  This
defaults to the /lib/modules directory.

=item B<-k --kernel>

Kernel binary for the target.  You must either supply a kernel binary
or a kernel symbol file (using the -F option).

=item B<-F --kernelsyms>

Kernel symbol file for the target.  You must supply either a kernel symbol file
kernel binary for the target (using the -k option).

=item B<-n --stdout>

Write to stdout instead of modules.dep.  This is currently hard coded...
kernel binary for the target (using the -k option).

=item B<--verbose>

Be verbose (not implemented)

=back

=head1 COPYRIGHT

Copyright (c) 2001 David Schleef <ds@schleef.org>
Copyright (c) 2001 Erik Andersen <andersen@codepoet.org>
Copyright (c) 2001 Stuart Hughes <stuarth@lineo.com>
This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=head1 AUTHOR

David Schleef <ds@schleef.org>

=cut

# $Id: depmod.pl,v 1.1 2004/12/08 01:34:41 andersen Exp $

