################################################################################
#
# perl-libwww-perl
#
################################################################################

PERL_LIBWWW_PERL_VERSION = 6.43
PERL_LIBWWW_PERL_SOURCE = libwww-perl-$(PERL_LIBWWW_PERL_VERSION).tar.gz
PERL_LIBWWW_PERL_SITE = $(BR2_CPAN_MIRROR)/authors/id/O/OA/OALDERS
PERL_LIBWWW_PERL_LICENSE = Artistic or GPL-1.0+
PERL_LIBWWW_PERL_LICENSE_FILES = LICENSE
PERL_LIBWWW_PERL_DISTNAME = libwww-perl

$(eval $(perl-package))
