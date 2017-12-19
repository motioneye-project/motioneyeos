################################################################################
#
# granite
#
################################################################################

GRANITE_VERSION_MAJOR = 0.4
GRANITE_VERSION = $(GRANITE_VERSION_MAJOR).1
GRANITE_SITE = https://launchpad.net/granite/$(GRANITE_VERSION_MAJOR)/$(GRANITE_VERSION)/+download
GRANITE_SOURCE = granite-$(GRANITE_VERSION).tar.xz
GRANITE_DEPENDENCIES = host-pkgconf host-vala libgee libglib2 libgtk3
GRANITE_INSTALL_STAGING = YES
GRANITE_LICENSE = LGPL-3.0+
GRANITE_LICENSE_FILES = COPYING

$(eval $(cmake-package))
