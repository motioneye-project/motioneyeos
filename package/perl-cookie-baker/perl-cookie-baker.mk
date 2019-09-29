################################################################################
#
# perl-cookie-baker
#
################################################################################

PERL_COOKIE_BAKER_VERSION = 0.10
PERL_COOKIE_BAKER_SOURCE = Cookie-Baker-$(PERL_COOKIE_BAKER_VERSION).tar.gz
PERL_COOKIE_BAKER_SITE = $(BR2_CPAN_MIRROR)/authors/id/K/KA/KAZEBURO
PERL_COOKIE_BAKER_DEPENDENCIES = host-perl-module-build-tiny
PERL_COOKIE_BAKER_LICENSE = Artistic or GPL-1.0+
PERL_COOKIE_BAKER_LICENSE_FILES = LICENSE
PERL_COOKIE_BAKER_DISTNAME = Cookie-Baker

$(eval $(perl-package))
