################################################################################
#
# aoetools
#
################################################################################

AOETOOLS_VERSION = 37
AOETOOLS_SITE = $(call github,OpenAoE,aoetools,aoetools-$(AOETOOLS_VERSION))
AOETOOLS_LICENSE = GPL-2.0
AOETOOLS_LICENSE_FILES = COPYING

define AOETOOLS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define AOETOOLS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) DESTDIR=$(TARGET_DIR) \
		-C $(@D) install
endef

$(eval $(generic-package))
