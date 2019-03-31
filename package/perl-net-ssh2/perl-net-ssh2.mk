################################################################################
#
# perl-net-ssh2
#
################################################################################

PERL_NET_SSH2_VERSION = 0.70
PERL_NET_SSH2_SOURCE = Net-SSH2-$(PERL_NET_SSH2_VERSION).tar.gz
PERL_NET_SSH2_SITE = $(BR2_CPAN_MIRROR)/authors/id/S/SA/SALVA
PERL_NET_SSH2_LICENSE = Artistic or GPL-1.0+
PERL_NET_SSH2_LICENSE_FILES = README
PERL_NET_SSH2_DEPENDENCIES = libssh2 zlib
PERL_NET_SSH2_DISTNAME = Net-SSH2

# build system will use host search paths by default
PERL_NET_SSH2_CONF_OPTS += \
	lib="$(STAGING_DIR)/usr/lib" \
	inc="$(STAGING_DIR)/usr/include"

ifeq ($(BR2_PACKAGE_LIBSSH2_LIBGCRYPT),y)
PERL_NET_SSH2_CONF_OPTS += gcrypt
endif

$(eval $(perl-package))
