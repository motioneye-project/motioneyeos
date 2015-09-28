################################################################################
#
# stress-ng
#
################################################################################

STRESS_NG_VERSION = 0.04.16
STRESS_NG_SITE = http://kernel.ubuntu.com/~cking/tarballs/stress-ng
STRESS_NG_LICENSE = GPLv2+
STRESS_NG_LICENSE_FILES = COPYING

STRESS_NG_DEPENDENCIES = attr keyutils

define STRESS_NG_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define STRESS_NG_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) DESTDIR=$(TARGET_DIR) -C $(@D) install
endef

$(eval $(generic-package))
