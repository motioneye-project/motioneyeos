################################################################################
#
# i2c-tools
#
################################################################################

I2C_TOOLS_VERSION = v3.1.2
I2C_TOOLS_SITE = git://git.kernel.org/pub/scm/utils/i2c-tools/i2c-tools.git
I2C_TOOLS_LICENSE = GPL-2.0+, GPL-2.0 (py-smbus)
I2C_TOOLS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_PYTHON),y)
I2C_TOOLS_DEPENDENCIES += python
endif

ifeq ($(BR2_PACKAGE_PYTHON3),y)
I2C_TOOLS_DEPENDENCIES += python3
endif

ifeq ($(BR2_PACKAGE_BUSYBOX),y)
I2C_TOOLS_DEPENDENCIES += busybox
endif

# Build/install steps mirror the distutil python package type in the python package
# infrastructure
ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
# BASE_ENV taken from PKG_PYTHON_DISTUTILS_ENV in package/pkg-python.mk
I2C_TOOLS_PYTHON_BASE_ENV = \
	$(PKG_PYTHON_DISTUTILS_ENV) \
	CFLAGS="$(TARGET_CFLAGS) -I../include"

define I2C_TOOLS_BUILD_PYSMBUS
	(cd $(@D)/py-smbus; \
	$(I2C_TOOLS_PYTHON_BASE_ENV) \
		$(HOST_DIR)/bin/python setup.py build \
		$(PKG_PYTHON_DISTUTILS_BUILD_OPTS))
endef

define I2C_TOOLS_INSTALL_PYSMBUS
	(cd $(@D)/py-smbus; \
	$(I2C_TOOLS_PYTHON_BASE_ENV) \
		$(HOST_DIR)/bin/python setup.py install \
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
		$(INSTALL) -m 755 -D $(@D)/tools/$$i $(TARGET_DIR)/usr/sbin/$$i; \
	done
	$(I2C_TOOLS_INSTALL_PYSMBUS)
endef

$(eval $(generic-package))
