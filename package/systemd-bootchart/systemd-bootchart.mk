################################################################################
#
# systemd-bootchart
#
################################################################################

SYSTEMD_BOOTCHART_VERSION = 233
SYSTEMD_BOOTCHART_SOURCE = systemd-bootchart-$(SYSTEMD_BOOTCHART_VERSION).tar.xz
# Do not use the github helper here: the uploaded release tarball already
# contains the generated autotools scripts. It also slightly differs with
# two missing source files... :-/
SYSTEMD_BOOTCHART_SITE = https://github.com/systemd/systemd-bootchart/releases/download/v$(SYSTEMD_BOOTCHART_VERSION)
SYSTEMD_BOOTCHART_LICENSE = LGPL-2.1+
SYSTEMD_BOOTCHART_LICENSE_FILES = LICENSE.LGPL2.1
SYSTEMD_BOOTCHART_DEPENDENCIES = systemd

SYSTEMD_BOOTCHART_CONF_OPTS = --disable-man

define SYSTEMD_BOOTCHART_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/etc/systemd/system/sysinit.target.wants
	ln -sf ../../../../lib/systemd/system/systemd-bootchart.service \
		$(TARGET_DIR)/etc/systemd/system/sysinit.target.wants/systemd-bootchart.service
endef

$(eval $(autotools-package))
