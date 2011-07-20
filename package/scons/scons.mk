SCONS_VERSION = 2.0.1
SCONS_SOURCE = scons-$(SCONS_VERSION).tar.gz
SCONS_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/scons

define HOST_SCONS_BUILD_CMDS
	(cd $(@D); python setup.py build)
endef

define HOST_SCONS_INSTALL_CMDS
	(cd $(@D); python setup.py install --prefix=$(HOST_DIR)/usr)
endef

$(eval $(call GENTARGETS,package,scons,host))
