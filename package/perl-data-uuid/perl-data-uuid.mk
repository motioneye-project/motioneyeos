################################################################################
#
# perl-data-uuid
#
################################################################################

PERL_DATA_UUID_VERSION = 1.226
PERL_DATA_UUID_SOURCE = Data-UUID-$(PERL_DATA_UUID_VERSION).tar.gz
PERL_DATA_UUID_SITE = $(BR2_CPAN_MIRROR)/authors/id/R/RJ/RJBS
# The license is documented at
# https://fedoraproject.org/wiki/Licensing:MIT#HP_Variant as the "HP
# Variant" of the MIT license. There is no official SPDX tag for this
# license, but the other MIT variants are prefixed with "MIT-", so we
# do the same here.
PERL_DATA_UUID_LICENSE = MIT-HP
PERL_DATA_UUID_LICENSE_FILES = LICENSE
PERL_DATA_UUID_DISTNAME = Data-UUID

$(eval $(perl-package))
