################################################################################
#
# perl-path-tiny
#
################################################################################

PERL_PATH_TINY_VERSION = 0.061
PERL_PATH_TINY_SOURCE = Path-Tiny-$(PERL_PATH_TINY_VERSION).tar.gz
PERL_PATH_TINY_SITE = $(BR2_CPAN_MIRROR)/authors/id/D/DA/DAGOLDEN
PERL_PATH_TINY_DEPENDENCIES = perl
PERL_PATH_TINY_LICENSE = Apache-2.0
PERL_PATH_TINY_LICENSE_FILES = LICENSE

$(eval $(perl-package))
