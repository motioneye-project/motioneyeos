################################################################################
#
# perl-filesys-notify-simple
#
################################################################################

PERL_FILESYS_NOTIFY_SIMPLE_VERSION = 0.13
PERL_FILESYS_NOTIFY_SIMPLE_SOURCE = Filesys-Notify-Simple-$(PERL_FILESYS_NOTIFY_SIMPLE_VERSION).tar.gz
PERL_FILESYS_NOTIFY_SIMPLE_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MI/MIYAGAWA
PERL_FILESYS_NOTIFY_SIMPLE_LICENSE = Artistic or GPL-1.0+
PERL_FILESYS_NOTIFY_SIMPLE_LICENSE_FILES = LICENSE
PERL_FILESYS_NOTIFY_SIMPLE_DISTNAME = Filesys-Notify-Simple

$(eval $(perl-package))
