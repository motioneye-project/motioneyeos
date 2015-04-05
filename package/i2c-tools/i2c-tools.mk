################################################################################
#
# i2c-tools
#
################################################################################

I2C_TOOLS_VERSION = 3.1.1
I2C_TOOLS_SOURCE = i2c-tools-$(I2C_TOOLS_VERSION).tar.bz2
I2C_TOOLS_SITE = http://dl.lm-sensors.org/i2c-tools/releases
I2C_TOOLS_LICENSE = GPLv2+, GPLv2 (py-smbus)
I2C_TOOLS_LICENSE_FILES = COPYING

# Build/install steps mirror the distutil python package type in the python package
# infrastructure
ifeq ($(BR2_PACKAGE_PYTHON),y)
I2C_TOOLS_DEPENDENCIES += python
# BASE_ENV taken from PKG_PYTHON_DISTUTILS_ENV in package/pkg-python.mk
I2C_TOOLS_PYTHON_BASE_ENV = \
	$(PKG_PYTHON_DISTUTILS_ENV) \
	CFLAGS="$(TARGET_CFLAGS) -I../include"

define I2C_TOOLS_BUILD_PYSMBUS
	(cd $(@D)/py-smbus;  \
	$(I2C_TOOLS_PYTHON_BASE_ENV) \
		$(HOST_DIR)/usr/bin/python setup.py build \
		$(PKG_PYTHON_DISTUTILS_BUILD_OPTS))
endef

define I2C_TOOLS_INSTALL_PYSMBUS
	(cd $(@D)/py-smbus; \
	$(I2C_TOOLS_PYTHON_BASE_ENV) \
		$(HOST_DIR)/usr/bin/python setup.py install \
		$(PKG_PYTHON_DISTUTILS_INSTALL_TARGET_OPTS))
endef

endif # BR2_PACKAGE_PYTHON

define I2C_TOOLS_BUILD_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
	$(I2C_TOOLS_BUILD_PYSMBUS)
endef

define I2C_TOOLS_INSTALL_TARGET_CMDS
	for i in i2cdump i2cget i2cset i2cdetect; \
	do \
		$(INSTALL) -m 755 -D $(@D)/tools/$$i $(TARGET_DIR)/usr/bin/$$i; \
	done
	$(I2C_TOOLS_INSTALL_PYSMBUS)
endef

$(eval $(generic-package))
