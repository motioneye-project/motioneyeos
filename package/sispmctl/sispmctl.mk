################################################################################
#
# sispmctl
#
################################################################################

SISPMCTL_VERSION = 3.1
SISPMCTL_SITE = http://downloads.sourceforge.net/project/sispmctl/sispmctl/sispmctl-$(SISPMCTL_VERSION)
SISPMCTL_LICENSE = GPLv2+
SISPMCTL_LICENSE_FILES = LICENCE
SISPMCTL_DEPENDENCIES = libusb-compat

SISPMCTL_CONF_ENV = HAVELIBUSB=$(STAGING_DIR)/usr/bin/libusb-config
SISPMCTL_CONF_OPT = --enable-webless

$(eval $(autotools-package))
