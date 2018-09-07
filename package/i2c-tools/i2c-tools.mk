################################################################################
#
# i2c-tools
#
################################################################################

I2C_TOOLS_VERSION = 4.0
I2C_TOOLS_SOURCE = i2c-tools-$(I2C_TOOLS_VERSION).tar.xz
I2C_TOOLS_SITE = https://www.kernel.org/pub/software/utils/i2c-tools
I2C_TOOLS_LICENSE = GPL-2.0+, GPL-2.0 (py-smbus), LGPL-2.1+ (libi2c)
I2C_TOOLS_LICENSE_FILES = COPYING COPYING.LGPL README
I2C_TOOLS_MAKE_OPTS = EXTRA=eeprog
I2C_TOOLS_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_PYTHON),y)
I2C_TOOLS_DEPENDENCIES += python
endif

ifeq ($(BR2_PACKAGE_PYTHON3),y)
I2C_TOOLS_DEPENDENCIES += python3
endif

ifeq ($(BR2_STATIC_LIBS),y)
I2C_TOOLS_MAKE_OPTS += BUILD_DYNAMIC_LIB=0 USE_STATIC_LIB=1
endif

ifeq ($(BR2_SHARED_LIBS),y)
I2C_TOOLS_MAKE_OPTS += BUILD_STATIC_LIB=0
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
	$(MAKE) $(TARGET_CONFIGURE_OPTS) $(I2C_TOOLS_MAKE_OPTS) -C $(@D)
	$(I2C_TOOLS_BUILD_PYSMBUS)
endef

define I2C_TOOLS_INSTALL_TARGET_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) $(I2C_TOOLS_MAKE_OPTS) \
		DESTDIR="$(TARGET_DIR)" prefix=/usr -C $(@D) install
	$(I2C_TOOLS_INSTALL_PYSMBUS)
endef

define I2C_TOOLS_INSTALL_STAGING_CMDS
	$(MAKE) $(TARGET_CONFIGURE_OPTS) $(I2C_TOOLS_MAKE_OPTS) \
		DESTDIR="$(STAGING_DIR)" prefix=/usr -C $(@D) install
endef

$(eval $(generic-package))
