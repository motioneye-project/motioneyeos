################################################################################
#
# lmbench
#
################################################################################

LMBENCH_VERSION = 3.0-a9
LMBENCH_SOURCE = lmbench-$(LMBENCH_VERSION).tgz
LMBENCH_SITE = http://downloads.sourceforge.net/project/lmbench/development/lmbench-$(LMBENCH_VERSION)
LMBENCH_LICENSE = lmbench license (based on GPLv2)
LMBENCH_LICENSE_FILES = COPYING COPYING-2

LMBENCH_CFLAGS = $(TARGET_CFLAGS)

ifeq ($(BR2_PACKAGE_LIBTIRPC),y)
LMBENCH_DEPENDENCIES += host-pkgconf libtirpc
LMBENCH_CFLAGS += `$(PKG_CONFIG_HOST_BINARY) --cflags libtirpc`
LMBENCH_LDLIBS = `$(PKG_CONFIG_HOST_BINARY) --libs libtirpc`
endif

define LMBENCH_CONFIGURE_CMDS
	$(call CONFIG_UPDATE,$(@D))
	sed -i 's/CFLAGS=/CFLAGS+=/g' $(@D)/src/Makefile
	sed -i 's/LDLIBS=/LDLIBS+=/g' $(@D)/scripts/build
	sed -i '/cd .*doc/d' $(@D)/src/Makefile
	sed -i '/include/d' $(@D)/src/Makefile
	touch $@
endef

# Note: there is a second stage 'make' invocation from the 'scripts/build'
# script. So the variables override below don't take direct effect in
# src/Makefile.
define LMBENCH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CFLAGS="$(LMBENCH_CFLAGS)" LDLIBS="$(LMBENCH_LDLIBS)" OS=$(ARCH) CC="$(TARGET_CC)" -C $(@D)/src
endef

define LMBENCH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) CFLAGS="$(TARGET_CFLAGS)" OS=$(ARCH) CC="$(TARGET_CC)" BASE=$(TARGET_DIR)/usr -C $(@D)/src install
endef

$(eval $(generic-package))
