################################################################################
#
# am33x-cm3
#
################################################################################

# This should correpsond to v05.00.00.02
AM33X_CM3_VERSION = 11107db2f1e9e58ee75d4fe9cc38423c9a6e4365
AM33X_CM3_SITE = http://arago-project.org/git/projects/am33x-cm3.git
AM33X_CM3_SITE_METHOD = git
AM33X_CM3_LICENSE = TI Publicly Available Software License
AM33X_CM3_LICENSE_FILES = License.txt

# The build command below will use the standard cross-compiler (normally
# build for Cortex-A8, to build the FW for the Cortex-M3.
define AM33X_CM3_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" CROSS_COMPILE="$(TARGET_CROSS)" -C $(@D) all
endef

# Not all of the firmware files are used
define AM33X_CM3_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0644 -D $(@D)/bin/am335x-pm-firmware.bin \
		$(TARGET_DIR)/lib/firmware/am335x-pm-firmware.bin
endef

define AM33X_CM3_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/am33x-cm3/S93-am335x-pm-firmware-load \
		$(TARGET_DIR)/etc/init.d/S93-am335x-pm-firmware-load
endef

$(eval $(generic-package))
