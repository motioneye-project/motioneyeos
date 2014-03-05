################################################################################
#
# scons
#
################################################################################

SCONS_VERSION = 2.3.0
SCONS_SITE = http://downloads.sourceforge.net/project/scons/scons/$(SCONS_VERSION)
SCONS_LICENSE = MIT
SCONS_LICENSE_FILES = LICENSE.txt
SCONS_SETUP_TYPE = distutils

HOST_SCONS_NEEDS_HOST_PYTHON = python2

HOST_SCONS_INSTALL_OPT = \
	--install-lib=$(HOST_DIR)/usr/lib/scons-$(SCONS_VERSION)

$(eval $(host-python-package))

# variables used by other packages
SCONS = $(HOST_DIR)/usr/bin/python2 $(HOST_DIR)/usr/bin/scons
