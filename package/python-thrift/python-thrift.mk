################################################################################
#
# python-thrift
#
################################################################################

PYTHON_THRIFT_VERSION = 0.9.1
PYTHON_THRIFT_SOURCE = thrift-$(PYTHON_THRIFT_VERSION).tar.gz
PYTHON_THRIFT_SITE = http://www.us.apache.org/dist/thrift/$(PYTHON_THRIFT_VERSION)
PYTHON_THRIFT_LICENSE = Apache-2.0
PYTHON_THRIFT_LICENSE_FILES = LICENSE
PYTHON_THRIFT_DEPENDENCIES = python

define PYTHON_THRIFT_BUILD_CMDS
	(cd $(@D)/lib/py; \
		CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDSHARED="$(TARGET_CROSS)gcc -shared" \
		CROSS_COMPILING=yes \
		_python_sysroot=$(STAGING_DIR) \
		_python_srcdir=$(BUILD_DIR)/python$(PYTHON_VERSION) \
		_python_prefix=/usr \
		_python_exec_prefix=/usr \
		$(HOST_DIR)/usr/bin/python setup.py build)
endef

# host-distutilscross, if it has been installed before, will check that
# the installation directory is in python's load path. For host-python,
# it is not, so add it explicitly while installing to target.
define PYTHON_THRIFT_INSTALL_TARGET_CMDS
	(cd $(@D)/lib/py; PYTHONPATH=$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages \
		$(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
