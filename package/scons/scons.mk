SCONS_VERSION = 2.0.1
SCONS_SOURCE = scons-$(SCONS_VERSION).tar.gz
SCONS_SITE = http://downloads.sourceforge.net/project/scons/scons/$(SCONS_VERSION)

define HOST_SCONS_BUILD_CMDS
	(cd $(@D); python setup.py build)
endef

define HOST_SCONS_INSTALL_CMDS
	(cd $(@D); python setup.py install --prefix=$(HOST_DIR)/usr)
endef

$(eval $(host-generic-package))

# variables used by other packages
SCONS = $(HOST_DIR)/usr/bin/scons
