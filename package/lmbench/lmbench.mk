################################################################################
#
# lmbench
#
################################################################################

LMBENCH_VERSION = 3.0-a9
LMBENCH_SOURCE = lmbench-$(LMBENCH_VERSION).tgz
LMBENCH_SITE = http://downloads.sourceforge.net/project/lmbench/development/lmbench-$(LMBENCH_VERSION)/
LMBENCH_LICENSE =  lmbench license (based on GPLv2)
LMBENCH_LICENSE_FILES = COPYING COPYING-2

LMBENCH_CFLAGS = $(TARGET_CFLAGS)
LMBENCH_LDLIBS = $(TARGET_LDFLAGS)

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
LMBENCH_DEPENDENCIES += libtirpc
LMBENCH_CFLAGS += -I$(STAGING_DIR)/usr/include/tirpc/
LMBENCH_LDFLAGS += -ltirpc
endif

define LMBENCH_CONFIGURE_CMDS
	$(call CONFIG_UPDATE,$(@D))
	sed -i 's/CFLAGS=/CFLAGS+=/g' $(@D)/src/Makefile
	sed -i '/cd .*doc/d' $(@D)/src/Makefile
	sed -i '/include/d' $(@D)/src/Makefile
	touch $@
endef

define LMBENCH_BUILD_CMDS
	$(MAKE) CFLAGS="$(LMBENCH_CFLAGS)" LDFLAGS="$(LMBENCH_LDFLAGS)" OS=$(ARCH) CC="$(TARGET_CC)" -C $(@D)/src
endef

define LMBENCH_INSTALL_TARGET_CMDS
	$(MAKE) CFLAGS="$(TARGET_CFLAGS)" OS=$(ARCH) CC="$(TARGET_CC)" BASE=$(TARGET_DIR)/usr -C $(@D)/src install
endef

define LMBENCH_CLEAN_CMDS
	$(MAKE) -C $(@D)/src clean
endef

$(eval $(generic-package))
