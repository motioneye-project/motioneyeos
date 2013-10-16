################################################################################
#
# scons
#
################################################################################

SCONS_VERSION = 2.3.0
SCONS_SITE = http://downloads.sourceforge.net/project/scons/scons/$(SCONS_VERSION)
SCONS_LICENSE = MIT
SCONS_LICENSE_FILES = LICENSE.txt

define HOST_SCONS_BUILD_CMDS
	(cd $(@D); python setup.py build)
endef

define HOST_SCONS_INSTALL_CMDS
	(cd $(@D); python setup.py install --prefix=$(HOST_DIR)/usr \
		--install-lib=$(HOST_DIR)/usr/lib/scons-$(SCONS_VERSION))
endef

$(eval $(host-generic-package))

# variables used by other packages
SCONS = $(HOST_DIR)/usr/bin/scons
