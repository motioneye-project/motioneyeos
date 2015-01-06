################################################################################
#
# dvb-apps
#
################################################################################

DVB_APPS_VERSION = 3d43b280298c39a67d1d889e01e173f52c12da35
DVB_APPS_SITE = http://linuxtv.org/hg/dvb-apps
DVB_APPS_SITE_METHOD = hg
DVB_APPS_LICENSE = GPLv2 GPLv2+ LGPLv2.1+
DVB_APPS_LICENSE_FILES = COPYING COPYING.LGPL

ifeq ($(BR2_ENABLE_LOCALE),)
DVB_APPS_DEPENDENCIES = libiconv
DVB_APPS_LDLIBS += -liconv
endif

ifeq ($(BR2_STATIC_LIBS),y)
DVB_APPS_MAKE_OPTS += enable_shared=no
else ifeq ($(BR2_SHARED_LIBS),y)
DVB_APPS_MAKE_OPTS += enable_static=no
endif

DVB_APPS_INSTALL_STAGING = YES

define DVB_APPS_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) LDLIBS="$(DVB_APPS_LDLIBS)" \
		$(MAKE) -C $(@D) CROSS_ROOT=$(STAGING_DIR) \
		$(DVB_APPS_MAKE_OPTS)
endef

define DVB_APPS_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) $(DVB_APPS_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install
endef

define DVB_APPS_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) $(DVB_APPS_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
endef

$(eval $(generic-package))
