################################################################################
#
# perl-net-ssleay
#
################################################################################

PERL_NET_SSLEAY_VERSION = 1.68
PERL_NET_SSLEAY_SOURCE = Net-SSLeay-$(PERL_NET_SSLEAY_VERSION).tar.gz
PERL_NET_SSLEAY_SITE = $(BR2_CPAN_MIRROR)/authors/id/M/MI/MIKEM
PERL_NET_SSLEAY_DEPENDENCIES = perl openssl
PERL_NET_SSLEAY_LICENSE = OpenSSL
PERL_NET_SSLEAY_LICENSE_FILES = LICENSE

# Try as hard as possible to remedy to the brain-damage their build-system
# suffers from: don't search for openssl, they pick the host-system one.
PERL_NET_SSLEAY_CONF_ENV = OPENSSL_PREFIX=$(STAGING_DIR)/usr

# Remove problematic single quotes in LDDLFLAGS, CCFLAGS & OPTIMIZE definition
define PERL_NET_SSLEAY_FIX_MAKEFILE
	$(SED) "s/^LDDLFLAGS = '\(.*\)'/LDDLFLAGS = \1/" $(@D)/Makefile
	$(SED) "s/^CCFLAGS = '\(.*\)'/CCFLAGS = \1/" $(@D)/Makefile
	$(SED) "s/^OPTIMIZE = '\(.*\)'/OPTIMIZE = \1/" $(@D)/Makefile
endef
PERL_NET_SSLEAY_POST_CONFIGURE_HOOKS += PERL_NET_SSLEAY_FIX_MAKEFILE

$(eval $(perl-package))
