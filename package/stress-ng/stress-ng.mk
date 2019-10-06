################################################################################
#
# stress-ng
#
################################################################################

STRESS_NG_VERSION = 0.10.07
STRESS_NG_SOURCE = stress-ng-$(STRESS_NG_VERSION).tar.xz
STRESS_NG_SITE = http://kernel.ubuntu.com/~cking/tarballs/stress-ng
STRESS_NG_LICENSE = GPL-2.0+
STRESS_NG_LICENSE_FILES = COPYING

STRESS_NG_DEPENDENCIES = attr keyutils

ifeq ($(BR2_PACKAGE_LIBBSD),y)
STRESS_NG_DEPENDENCIES += libbsd
endif

define STRESS_NG_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

# Don't use make install otherwise stress-ng will be rebuild without
# required link libraries if any. Furthermore, using INSTALL allow to
# set the file permission correcly on the target.
define STRESS_NG_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/stress-ng $(TARGET_DIR)/usr/bin/stress-ng
endef

$(eval $(generic-package))
