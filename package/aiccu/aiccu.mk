################################################################################
#
# aiccu
#
################################################################################

AICCU_VERSION = 20070115
AICCU_SOURCE = aiccu_$(AICCU_VERSION).tar.gz
AICCU_SITE = http://www.sixxs.net/archive/sixxs/aiccu/unix
AICCU_LICENSE = SixXS License, concise redistribution license
AICCU_LICENSE_FILES = doc/LICENSE
AICCU_DEPENDENCIES = gnutls

AICCU_LFDLAGS = $(TARGET_LDFLAGS)

# aiccu forgets to link with gnutls' dependencies breaking the build when
# linking statically
ifeq ($(BR2_STATIC_LIBS),y)
AICCU_LDFLAGS += $(shell $(PKG_CONFIG_HOST_BINARY) --static --libs gnutls)
endif

# dummy RPM_OPT_FLAGS to disable stripping
define AICCU_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) LDFLAGS="$(AICCU_LDFLAGS)" $(MAKE) \
		CC="$(TARGET_CC)" RPM_OPT_FLAGS=1 -C $(@D)/unix-console all
endef

define AICCU_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/unix-console/aiccu \
		$(TARGET_DIR)/usr/sbin/aiccu
	$(INSTALL) -D -m 0644 $(@D)/doc/aiccu.conf \
		$(TARGET_DIR)/etc/aiccu.conf
endef

define AICCU_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(@D)/doc/aiccu.init \
		$(TARGET_DIR)/etc/init.d/S50aiccu
endef

$(eval $(generic-package))
