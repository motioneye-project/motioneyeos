################################################################################
#
# dropbear
#
################################################################################

DROPBEAR_VERSION = 2013.58
DROPBEAR_SITE = http://matt.ucc.asn.au/dropbear/releases
DROPBEAR_SOURCE = dropbear-$(DROPBEAR_VERSION).tar.bz2
DROPBEAR_TARGET_BINS = dbclient dropbearkey dropbearconvert scp ssh
DROPBEAR_MAKE =	$(MAKE) MULTI=1 SCPPROGRESS=1 \
		PROGRAMS="dropbear dbclient dropbearkey dropbearconvert scp"

DROPBEAR_LICENSE = MIT, BSD-2c-like, BSD-2c
DROPBEAR_LICENSE_FILES = LICENSE

ifeq ($(BR2_PREFER_STATIC_LIB),y)
DROPBEAR_MAKE += STATIC=1
endif

define DROPBEAR_FIX_XAUTH
	$(SED) 's,^#define XAUTH_COMMAND.*/xauth,#define XAUTH_COMMAND "/usr/bin/xauth,g' $(@D)/options.h
endef

DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_FIX_XAUTH

define DROPBEAR_DISABLE_REVERSE_DNS
	$(SED) 's:\(#define DO_HOST_LOOKUP\):/*\1 */:' $(@D)/options.h
endef

define DROPBEAR_BUILD_SMALL
	$(SED) 's:.*\(#define DROPBEAR_SMALL_CODE\).*:\1:' $(@D)/options.h
	$(SED) 's:.*\(#define NO_FAST_EXPTMOD\).*:\1:' $(@D)/options.h
endef

define DROPBEAR_BUILD_FEATURED
	$(SED) 's:.*\(#define DROPBEAR_BLOWFISH\).*:\1:' $(@D)/options.h
	$(SED) 's:.*\(#define DROPBEAR_SHA2_256_HMAC\).*:\1:' $(@D)/options.h
	$(SED) 's:.*\(#define DROPBEAR_SHA2_512_HMAC\).*:\1:' $(@D)/options.h
endef

define DROPBEAR_DISABLE_STANDALONE
	$(SED) 's:\(#define NON_INETD_MODE\):/*\1 */:' $(@D)/options.h
endef

ifeq ($(BR2_USE_MMU),y)
define DROPBEAR_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/dropbear/S50dropbear \
		$(TARGET_DIR)/etc/init.d/S50dropbear
endef
else
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_DISABLE_STANDALONE
endif

ifeq ($(BR2_PACKAGE_DROPBEAR_DISABLE_REVERSEDNS),y)
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_DISABLE_REVERSE_DNS
endif

ifeq ($(BR2_PACKAGE_DROPBEAR_SMALL),y)
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_BUILD_SMALL
DROPBEAR_CONF_OPT += --disable-zlib
else
DROPBEAR_POST_EXTRACT_HOOKS += DROPBEAR_BUILD_FEATURED
DROPBEAR_DEPENDENCIES += zlib
endif

ifneq ($(BR2_PACKAGE_DROPBEAR_WTMP),y)
DROPBEAR_CONF_OPT += --disable-wtmp
endif

ifneq ($(BR2_PACKAGE_DROPBEAR_LASTLOG),y)
DROPBEAR_CONF_OPT += --disable-lastlog
endif

define DROPBEAR_INSTALL_TARGET_CMDS
	$(INSTALL) -m 755 $(@D)/dropbearmulti $(TARGET_DIR)/usr/sbin/dropbear
	for f in $(DROPBEAR_TARGET_BINS); do \
		ln -snf ../sbin/dropbear $(TARGET_DIR)/usr/bin/$$f ; \
	done
endef

$(eval $(autotools-package))
