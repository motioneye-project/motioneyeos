################################################################################
#
# systemd-bootchart
#
################################################################################

SYSTEMD_BOOTCHART_VERSION = 230
SYSTEMD_BOOTCHART_SOURCE = systemd-bootchart-$(SYSTEMD_BOOTCHART_VERSION).tar.xz
# Do not use the github helper here, the generated tarball is *NOT* the same
# as the one uploaded by upstream for the release.
SYSTEMD_BOOTCHART_SITE = https://github.com/systemd/systemd-bootchart/releases/download/v$(SYSTEMD_BOOTCHART_VERSION)
SYSTEMD_BOOTCHART_LICENSE = LGPLv2.1+
SYSTEMD_BOOTCHART_LICENSE_FILES = LICENSE.LGPL2.1
SYSTEMD_BOOTCHART_DEPENDENCIES = host-intltool systemd

# 0001-configure-add-option-to-not-build-manpages.patch
SYSTEMD_BOOTCHART_AUTORECONF = YES
SYSTEMD_BOOTCHART_CONF_OPTS = --disable-man

define SYSTEMD_BOOTCHART_INTLTOOLIZE
        cd $(@D) && $(HOST_DIR)/usr/bin/intltoolize --force --automake
endef
SYSTEMD_BOOTCHART_PRE_CONFIGURE_HOOKS = SYSTEMD_BOOTCHART_INTLTOOLIZE

$(eval $(autotools-package))
