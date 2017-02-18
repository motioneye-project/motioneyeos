################################################################################
#
# perl-mojolicious
#
################################################################################

PERL_MOJOLICIOUS_VERSION = 6.25
PERL_MOJOLICIOUS_SOURCE = Mojolicious-$(PERL_MOJOLICIOUS_VERSION).tar.gz
PERL_MOJOLICIOUS_SITE = $(BR2_CPAN_MIRROR)/authors/id/S/SR/SRI
PERL_MOJOLICIOUS_LICENSE = Artistic-2.0
PERL_MOJOLICIOUS_LICENSE_FILES = LICENSE

$(eval $(perl-package))
