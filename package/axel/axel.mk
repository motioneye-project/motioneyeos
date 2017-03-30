################################################################################
#
# axel
#
################################################################################

AXEL_VERSION = 2.4
AXEL_SITE = http://sources.buildroot.net
AXEL_LICENSE = GPL-2.0+
AXEL_LICENSE_FILES = COPYING

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
AXEL_DEPENDENCIES += gettext
AXEL_LDFLAGS += -lintl
endif

# -lintl may use symbols from -lpthread
AXEL_LDFLAGS += -lpthread

ifneq ($(BR2_ENABLE_LOCALE),y)
AXEL_DISABLE_I18N = --i18n=0
endif

define AXEL_CONFIGURE_CMDS
	(cd $(@D); \
		./configure \
			--prefix=/usr \
			--debug=1 \
			$(AXEL_DISABLE_I18N) \
	)
endef

define AXEL_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
	LFLAGS="$(TARGET_LDFLAGS) $(AXEL_LDFLAGS)" -C $(@D)
endef

define AXEL_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
