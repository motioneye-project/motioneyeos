################################################################################
#
# ipmiutil
#
################################################################################

IPMIUTIL_VERSION = 3.1.2
IPMIUTIL_SITE = https://sourceforge.net/projects/ipmiutil/files
IPMIUTIL_LICENSE = BSD-3-Clause
IPMIUTIL_LICENSE_FILES = COPYING
# We're patching configure.ac
IPMIUTIL_AUTORECONF = YES

IPMIUTIL_MAKE = $(MAKE1)

# forgets to link against libcrypto dependencies breaking static link
ifeq ($(BR2_PACKAGE_OPENSSL)x$(BR2_STATIC_LIBS),yx)
# tests against distro libcrypto so it might get a false positive when
# the openssl version is old, so force it off
# SKIP_MD2 can be used only if ALLOW_GNU is defined.
IPMIUTIL_CONF_OPTS += CPPFLAGS="$(TARGET_CPPFLAGS) -DALLOW_GNU -DSKIP_MD2"
IPMIUTIL_DEPENDENCIES += openssl
else
IPMIUTIL_CONF_OPTS += --disable-lanplus
endif

$(eval $(autotools-package))
