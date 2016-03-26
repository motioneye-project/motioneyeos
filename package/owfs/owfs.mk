################################################################################
#
# owfs
#
################################################################################

OWFS_VERSION = 3.1p1
OWFS_SITE = http://downloads.sourceforge.net/project/owfs/owfs/$(OWFS_VERSION)
OWFS_DEPENDENCIES = host-pkgconf
OWFS_CONF_OPTS = --disable-owperl --without-perl5 --disable-owtcl --without-tcl

# 0001-configure.ac-check-for-localtime_r.patch touches configure.ac
OWFS_AUTORECONF = YES

# owtcl license is declared in module/ownet/c/src/include/ow_functions.h
OWFS_LICENSE = GPLv2+, LGPLv2 (owtcl)
OWFS_LICENSE_FILES = COPYING COPYING.LIB
OWFS_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_LIBFUSE),y)
OWFS_DEPENDENCIES += libfuse
OWFS_CONF_OPTS += \
	--enable-owfs \
	--with-fuseinclude=$(STAGING_DIR)/usr/include \
	--with-fuselib=$(STAGING_DIR)/usr/lib
define OWFS_INSTALL_FUSE_INIT_SYSV
	$(INSTALL) -D -m 0755 $(OWFS_PKGDIR)S30owfs \
		$(TARGET_DIR)/etc/init.d/S30owfs
endef
define OWFS_CREATE_MOUNTPOINT
	mkdir -p $(TARGET_DIR)/dev/1wire
endef
OWFS_POST_INSTALL_TARGET_HOOKS += OWFS_CREATE_MOUNTPOINT
else
OWFS_CONF_OPTS += --disable-owfs
endif

ifeq ($(BR2_PACKAGE_LIBUSB),y)
OWFS_CONF_OPTS += --enable-usb
OWFS_DEPENDENCIES += libusb
else
OWFS_CONF_OPTS += --disable-usb
endif

ifeq ($(BR2_PACKAGE_AVAHI),y)
OWFS_CONF_OPTS += --enable-avahi
OWFS_DEPENDENCIES += avahi
else
OWFS_CONF_OPTS += --disable-avahi
endif

ifeq ($(BR2_PACKAGE_PHP),y)
OWFS_CONF_OPTS += --enable-owphp --with-php --with-phpconfig=$(STAGING_DIR)/usr/bin/php-config
OWFS_DEPENDENCIES += php host-swig
else
OWFS_CONF_OPTS += --disable-owphp --without-php
endif

# setup.py isn't python3 compliant
ifeq ($(BR2_PACKAGE_PYTHON),y)
OWFS_CONF_OPTS += \
	--enable-owpython \
	--with-python \
	--with-pythonconfig=$(STAGING_DIR)/usr/bin/python-config
OWFS_MAKE_ENV += \
	CC="$(TARGET_CC)" \
	PYTHONPATH="$(PYTHON_PATH)" \
	_python_sysroot=$(STAGING_DIR) \
	_python_prefix=/usr \
	_python_exec_prefix=/usr
OWFS_DEPENDENCIES += python host-swig
else
OWFS_CONF_OPTS += --disable-owpython --without-python
endif

ifeq ($(BR2_STATIC_LIBS),y)
# zeroconf support uses dlopen()
OWFS_CONF_OPTS += --disable-zero
endif

define OWFS_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(OWFS_PKGDIR)S25owserver \
		$(TARGET_DIR)/etc/init.d/S25owserver
	$(OWFS_INSTALL_FUSE_INIT_SYSV)
endef

$(eval $(autotools-package))
