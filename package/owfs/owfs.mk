################################################################################
#
# owfs
#
################################################################################

OWFS_VERSION = 3.2p1
OWFS_SITE = http://downloads.sourceforge.net/project/owfs/owfs/$(OWFS_VERSION)
OWFS_DEPENDENCIES = host-pkgconf
OWFS_CONF_OPTS = --disable-owperl --without-perl5 --disable-owtcl --without-tcl

# 0001-configure.ac-check-for-localtime_r.patch touches configure.ac
OWFS_AUTORECONF = YES

# owtcl license is declared in module/ownet/c/src/include/ow_functions.h
OWFS_LICENSE = GPL-2.0+, LGPL-2.0 (owtcl)
OWFS_LICENSE_FILES = COPYING COPYING.LIB
OWFS_INSTALL_STAGING = YES

# owfs PHP support is not PHP 7 compliant
# https://sourceforge.net/p/owfs/support-requests/32/
OWFS_CONF_OPTS += --disable-owphp --without-php

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
# The configure scripts finds PYSITEDIR as the python_lib directory of
# host-python, and then prepends DESTDIR in front of it. So we end up
# installing things in $(TARGET_DIR)/$(HOST_DIR)/lib/python which is
# clearly wrong.
# Patching owfs to do the right thing is not trivial, it's much easier to
# override the PYSITEDIR variable in make.
OWFS_EXTRA_MAKE_OPTS += PYSITEDIR=/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages
else
OWFS_CONF_OPTS += --disable-owpython --without-python
endif

ifeq ($(BR2_STATIC_LIBS),y)
# zeroconf support uses dlopen()
OWFS_CONF_OPTS += --disable-zero
endif

OWFS_MAKE = $(MAKE) $(OWFS_EXTRA_MAKE_OPTS)

define OWFS_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(OWFS_PKGDIR)S25owserver \
		$(TARGET_DIR)/etc/init.d/S25owserver
	$(OWFS_INSTALL_FUSE_INIT_SYSV)
endef

$(eval $(autotools-package))
