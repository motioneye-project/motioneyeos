################################################################################
#
# python-thrift
#
################################################################################

PYTHON_THRIFT_VERSION = 0.9.0
PYTHON_THRIFT_SOURCE = thrift-$(PYTHON_THRIFT_VERSION).tar.gz
PYTHON_THRIFT_SITE = http://pypi.python.org/packages/source/t/thrift
PYTHON_THRIFT_LICENSE = Apache-2.0
PYTHON_THRIFT_LICENSE_FILES = README

PYTHON_THRIFT_DEPENDENCIES = python

define PYTHON_THRIFT_BUILD_CMDS
	(cd $(@D); \
		PYTHONXCPREFIX="$(STAGING_DIR)/usr/" \
		LDFLAGS="-L$(STAGING_DIR)/lib -L$(STAGING_DIR)/usr/lib" \
		$(HOST_DIR)/usr/bin/python setup.py build)
endef

# host-distutilscross, if it has been installed before, will check that
# the installation directory is in python's load path. For host-python,
# it is not, so add it explicitly while installing to target.
define PYTHON_THRIFT_INSTALL_TARGET_CMDS
	(cd $(@D); PYTHONPATH=$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages \
		$(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
