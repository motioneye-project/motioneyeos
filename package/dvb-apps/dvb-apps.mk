################################################################################
#
# dvb-apps
#
################################################################################

DVB_APPS_VERSION        = be76da69f250
DVB_APPS_SITE           = http://linuxtv.org/hg/dvb-apps
DVB_APPS_SITE_METHOD    = hg

# We just install the transponders data. As this is not a 'work' as per
# traditional copyright, but just a collection of 'facts', there's probably
# no license to apply to these data files.
# To be noted however, is that the dvb-apps package bundles a copy of the
# GPLv2 and a copy of the LGPLv2.1, and that some of the source files refer
# to either the GPLv2+ or the LGPLv2.1+.
# But since we do not use any of those source files, their license do not
# apply to us.
DVB_APPS_LICENSE        = unknown (probably public domain)

ifeq ($(BR2_PACKAGE_DVB_APPS_UTILS),y)
# Utilitiess are selected, build and install everything

DVB_APPS_LICENSE       += GPLv2 GPLv2+ LGPLv2.1+
DVB_APPS_LICENSE_FILES += COPYING COPYING.LGPL

DVB_APPS_LDFLAGS = $(TARGET_LDFLAGS)

ifeq ($(BR2_ENABLE_LOCALE),)
DVB_APPS_DEPENDENCIES    = libiconv
DVB_APPS_LDFLAGS        += -liconv
endif

DVB_APPS_INSTALL_STAGING = YES

define DVB_APPS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) LDFLAGS="$(DVB_APPS_LDFLAGS)" \
		$(MAKE) -C $(@D) CROSS_ROOT=$(STAGING_DIR) V=1
endef

define DVB_APPS_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) V=1 DESTDIR=$(STAGING_DIR) install
endef

define DVB_APPS_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) V=1 DESTDIR=$(TARGET_DIR) install
endef

else
# Utilities are not selected, just install the scan files
define DVB_APPS_INSTALL_TARGET_CMDS
	for i in atsc dvb-c dvb-s dvb-t; do \
		mkdir -p $(TARGET_DIR)/usr/share/dvb/$$i; \
		$(INSTALL) $(@D)/util/scan/$$i/* $(TARGET_DIR)/usr/share/dvb/$$i; \
	done
endef
endif

$(eval $(generic-package))
