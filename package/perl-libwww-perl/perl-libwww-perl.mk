################################################################################
#
# perl-libwww-perl
#
################################################################################

PERL_LIBWWW_PERL_VERSION = 6.34
PERL_LIBWWW_PERL_SOURCE = libwww-perl-$(PERL_LIBWWW_PERL_VERSION).tar.gz
PERL_LIBWWW_PERL_SITE = $(BR2_CPAN_MIRROR)/authors/id/E/ET/ETHER
PERL_LIBWWW_PERL_LICENSE = Artistic or GPL-1.0+
PERL_LIBWWW_PERL_LICENSE_FILES = LICENSE

$(eval $(perl-package))
