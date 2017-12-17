################################################################################
#
# systemd-bootchart
#
################################################################################

SYSTEMD_BOOTCHART_VERSION = 231
SYSTEMD_BOOTCHART_SOURCE = systemd-bootchart-$(SYSTEMD_BOOTCHART_VERSION).tar.xz
# Do not use the github helper here: the uploaded release tarball already
# contains the generated autotools scripts. It also slightly differs with
# two missing source files... :-/
SYSTEMD_BOOTCHART_SITE = https://github.com/systemd/systemd-bootchart/releases/download/v$(SYSTEMD_BOOTCHART_VERSION)
SYSTEMD_BOOTCHART_LICENSE = LGPLv2.1+
SYSTEMD_BOOTCHART_LICENSE_FILES = LICENSE.LGPL2.1
SYSTEMD_BOOTCHART_DEPENDENCIES = systemd

SYSTEMD_BOOTCHART_CONF_OPTS = --disable-man

$(eval $(autotools-package))
