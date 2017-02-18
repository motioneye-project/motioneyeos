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

SISPMCTL_CONF_OPTS = --enable-webless

# We're patching configure.in
SISPMCTL_AUTORECONF = YES

$(eval $(autotools-package))
