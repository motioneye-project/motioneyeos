################################################################################
#
# python-setuptools
#
################################################################################

# "distribute" is a fork of the unmaintained setuptools package. There
# are plans to re-merge it into setuptools; if this happens, we can
# switch back to it.
# See http://pypi.python.org/packages/source/s/setuptools

PYTHON_SETUPTOOLS_VERSION = 0.6.36
PYTHON_SETUPTOOLS_SOURCE  = distribute-$(PYTHON_SETUPTOOLS_VERSION).tar.gz
PYTHON_SETUPTOOLS_SITE    = http://pypi.python.org/packages/source/d/distribute
PYTHON_SETUPTOOLS_DEPENDENCIES = python

define HOST_PYTHON_SETUPTOOLS_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define PYTHON_SETUPTOOLS_BUILD_CMDS
	(cd $(@D); \
	PYTHONPATH="/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages" \
	$(HOST_DIR)/usr/bin/python setup.py build)
endef

define HOST_PYTHON_SETUPTOOLS_INSTALL_CMDS
	(cd $(@D); \
	PYTHONPATH="$(HOST_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages" \
	$(HOST_DIR)/usr/bin/python setup.py install --prefix=$(HOST_DIR)/usr)
endef

define PYTHON_SETUPTOOLS_INSTALL_TARGET_CMDS
	(cd $(@D); \
	PYTHONPATH="/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages" \
	$(HOST_DIR)/usr/bin/python setup.py install --executable=/usr/bin/python \
	--single-version-externally-managed --root=/ --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
