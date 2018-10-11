################################################################################
#
# perl-plack
#
################################################################################

PERL_PLACK_VERSION = 1.0047
PERL_PLACK_SOURCE = Plack-$(PERL_PLACK_VERSION).tar.gz
PERL_PLACK_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MI/MIYAGAWA
PERL_PLACK_DEPENDENCIES = host-perl-file-sharedir-install
PERL_PLACK_LICENSE = Artistic or GPL-1.0+
PERL_PLACK_LICENSE_FILES = LICENSE
PERL_PLACK_DISTNAME = Plack

$(eval $(perl-package))
