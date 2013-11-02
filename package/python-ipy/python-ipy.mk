################################################################################
#
# python-ipy
#
################################################################################

PYTHON_IPY_VERSION = IPy-0.75
PYTHON_IPY_SITE    = https://github.com/haypo/python-ipy/tarball/$(PYTHON_IPY_VERSION)
PYTHON_IPY_DEPENDENCIES = host-python python
PYTHON_IPY_LICENSE = BSD-3c
PYTHON_IPY_LICENSE_FILES = COPYING

define PYTHON_IPY_BUILD_CMDS
	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		$(HOST_DIR)/usr/bin/python setup.py build_ext \
		--include-dirs=$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR) \
	)
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define PYTHON_IPY_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
