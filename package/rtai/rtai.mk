################################################################################
#
# rtai
#
################################################################################

RTAI_VERSION = 4.0.1
RTAI_SOURCE = rtai-$(RTAI_VERSION).tar.bz2
RTAI_SITE = https://www.rtai.org/userfiles/downloads/RTAI
RTAI_INSTALL_STAGING = YES

# The <pkg>_CONFIG_SCRIPTS cannot apply here to the specificities of rtai-config
define RTAI_POST_PATCH_FIXUP
	$(SED) 's%^staging=.*%staging=$(STAGING_DIR)%' $(STAGING_DIR)/usr/bin/rtai-config
endef

RTAI_POST_INSTALL_STAGING_HOOKS += RTAI_POST_PATCH_FIXUP

RTAI_DEPENDENCIES = linux

RTAI_CONF_OPTS = \
	--includedir=/usr/include/rtai \
	--with-linux-dir=$(LINUX_DIR) \
	--disable-leds \
	--enable-usi \
	--enable-align-priority \
	--disable-rtailab \
	--with-module-dir=/lib/modules/$(LINUX_VERSION_PROBED)/rtai

RTAI_MAKE = $(MAKE1)

$(eval $(autotools-package))
