################################################################################
#
# util-linux-libs
#
################################################################################

UTIL_LINUX_LIBS_VERSION = $(UTIL_LINUX_VERSION)
UTIL_LINUX_LIBS_SOURCE = $(UTIL_LINUX_SOURCE)
UTIL_LINUX_LIBS_SITE = $(UTIL_LINUX_SITE)
UTIL_LINUX_LIBS_DL_SUBDIR = $(UTIL_LINUX_DL_SUBDIR)

# README.licensing claims that some files are GPL-2.0 only, but this is not true.
# Some files are GPL-3.0+ but only in tests. rfkill uses an ISC-style license.
UTIL_LINUX_LIBS_LICENSE = LGPL-2.1+ (libblkid, libfdisk, libmount, libsmartcols), BSD-3-Clause (libuuid)
UTIL_LINUX_LIBS_LICENSE_FILES = README.licensing \
	Documentation/licenses/COPYING.BSD-3-Clause \
	Documentation/licenses/COPYING.LGPL-2.1-or-later
UTIL_LINUX_LIBS_INSTALL_STAGING = YES
# Prevent installing the libraries twice on TARGET_DIR
UTIL_LINUX_LIBS_INSTALL_TARGET = $(if $(BR2_PACKAGE_UTIL_LINUX_PROGRAMS),NO,YES)
UTIL_LINUX_LIBS_DEPENDENCIES = host-pkgconf $(TARGET_NLS_DEPENDENCIES)
UTIL_LINUX_LIBS_CONF_OPTS += \
	--disable-rpath \
	--disable-makeinstall-chown
UTIL_LINUX_LIBS_LINK_LIBS = $(TARGET_NLS_LIBS)

# systemd depends on util-linux so we enable systemd support
# (which needs systemd to be installed)
UTIL_LINUX_LIBS_CONF_OPTS += \
	--without-systemd \
	--with-systemdsystemunitdir=no

HOST_UTIL_LINUX_LIBS_DEPENDENCIES = host-pkgconf
HOST_UTIL_LINUX_LIBS_CONF_OPTS = --disable-makeinstall-chown

# We also don't want the host-python dependency
HOST_UTIL_LINUX_LIBS_CONF_OPTS += --without-python

# Prevent the installation from attempting to move shared libraries from
# ${usrlib_execdir} (/usr/lib) to ${libdir} (/lib), since both paths are
# the same when merged usr is in use.
ifeq ($(BR2_ROOTFS_MERGED_USR),y)
UTIL_LINUX_LIBS_CONF_OPTS += --bindir=/usr/bin --sbindir=/usr/sbin --libdir=/usr/lib
endif

# Unfortunately, the util-linux does LIBS="" at the end of its
# configure script. So we have to pass the proper LIBS value when
# calling the configure script to make configure tests pass properly,
# and then pass it again at build time.
UTIL_LINUX_LIBS_CONF_ENV += LIBS="$(UTIL_LINUX_LIBS_LINK_LIBS)"
UTIL_LINUX_LIBS_MAKE_OPTS += LIBS="$(UTIL_LINUX_LIBS_LINK_LIBS)"

# libmount optionally uses selinux
ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBMOUNT)$(BR2_PACKAGE_LIBSELINUX),yy)
UTIL_LINUX_LIBS_DEPENDENCIES += libselinux
UTIL_LINUX_LIBS_CONF_OPTS += --with-selinux
else
UTIL_LINUX_LIBS_CONF_OPTS += --without-selinux
endif

# Disable utilities
UTIL_LINUX_LIBS_CONF_OPTS += \
	--disable-all-programs \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBBLKID),--enable-libblkid,--disable-libblkid) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBFDISK),--enable-libfdisk,--disable-libfdisk) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBMOUNT),--enable-libmount,--disable-libmount) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBSMARTCOLS),--enable-libsmartcols,--disable-libsmartcols) \
	$(if $(BR2_PACKAGE_UTIL_LINUX_LIBUUID),--enable-libuuid,--disable-libuuid)

# In the host version of util-linux-libs, we only require libuuid and libmount
# (plus libblkid as an indirect dependency of libmount). So disable libfdisk
# and libsmartcols, unless BR2_PACKAGE_HOST_UTIL_LINUX is set.
HOST_UTIL_LINUX_LIBS_CONF_OPTS += \
	--enable-libblkid \
	$(if $(BR2_PACKAGE_HOST_UTIL_LINUX),--enable-libfdisk,--disable-libfdisk) \
	--enable-libmount \
	$(if $(BR2_PACKAGE_HOST_UTIL_LINUX),--enable-libsmartcols,--disable-libsmartcols) \
	--enable-libuuid \
	--without-ncurses \
	--without-ncursesw \
	--without-tinfo

# Install libmount Python bindings
ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBMOUNT)$(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),yy)
UTIL_LINUX_LIBS_CONF_OPTS += --with-python --enable-pylibmount
UTIL_LINUX_LIBS_DEPENDENCIES += $(if $(BR2_PACKAGE_PYTHON),python,python3)
UTIL_LINUX_LIBS_CONF_OPTS += --without-python --disable-pylibmount
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
