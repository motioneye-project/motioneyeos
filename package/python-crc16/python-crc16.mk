################################################################################
#
# python-crc16
#
################################################################################

PYTHON_CRC16_VERSION = 0.1.1
PYTHON_CRC16_SOURCE = crc16-$(PYTHON_CRC16_VERSION).tar.gz
PYTHON_CRC16_SITE = http://pycrc16.googlecode.com/files/
PYTHON_CRC16_LICENSE = LGPLv3+
PYTHON_CRC16_LICENSE_FILES = COPYING.txt
PYTHON_CRC16_DEPENDENCIES = python host-python

PYTHON_CRC16_PARAMS = CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDSHARED="$(TARGET_CC) -shared" \
		LDFLAGS="$(TARGET_LDFLAGS) -L$(STAGING_DIR)/usr/lib" \
		CROSS_COMPILING=yes \
		_python_sysroot=$(STAGING_DIR) \
		_python_srcdir=$(PYTHON_DIR) \
		_python_prefix=/usr \
		_python_exec_prefix=/usr

define PYTHON_CRC16_BUILD_CMDS
	(cd $(@D); $(PYTHON_CRC16_PARAMS) \
		$(HOST_DIR)/usr/bin/python setup.py build)
endef

define PYTHON_CRC16_INSTALL_TARGET_CMDS
	(cd $(@D); $(PYTHON_CRC16_PARAMS) \
		$(HOST_DIR)/usr/bin/python setup.py install \
		--prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
