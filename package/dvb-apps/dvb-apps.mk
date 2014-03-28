################################################################################
#
# dvb-apps
#
################################################################################

DVB_APPS_VERSION        = be76da69f250
DVB_APPS_SITE           = http://linuxtv.org/hg/dvb-apps
DVB_APPS_SITE_METHOD    = hg

DVB_APPS_DEPENDENCIES   = dtv-scan-tables

ifeq ($(BR2_PACKAGE_DVB_APPS_UTILS),y)
# Utilitiess are selected, build and install everything

DVB_APPS_LICENSE        = GPLv2 GPLv2+ LGPLv2.1+
DVB_APPS_LICENSE_FILES  = COPYING COPYING.LGPL

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
# We do not really install anything, so there's no license
DVB_APPS_LICENSE        = none
endif

$(eval $(generic-package))
