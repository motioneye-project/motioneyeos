################################################################################
#
# axel
#
################################################################################

AXEL_VERSION = 2.4
AXEL_SITE = http://sources.buildroot.net
AXEL_LICENSE = GPLv2+
AXEL_LICENSE_FILES = COPYING

AXEL_LDFLAGS = -lpthread

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
AXEL_DEPENDENCIES += gettext
AXEL_LDFLAGS += -lintl
endif

ifneq ($(BR2_ENABLE_LOCALE),y)
AXEL_DISABLE_I18N=--i18n=0
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
	$(MAKE) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
	LFLAGS="$(TARGET_LDFLAGS) $(AXEL_LDFLAGS)" -C $(@D)
endef

define AXEL_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
