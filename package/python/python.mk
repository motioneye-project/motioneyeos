################################################################################
#
# python
#
################################################################################

PYTHON_VERSION_MAJOR = 2.7
PYTHON_VERSION       = $(PYTHON_VERSION_MAJOR).8
PYTHON_SOURCE        = Python-$(PYTHON_VERSION).tar.xz
PYTHON_SITE          = http://python.org/ftp/python/$(PYTHON_VERSION)
PYTHON_LICENSE       = Python software foundation license v2, others
PYTHON_LICENSE_FILES = LICENSE

# Python needs itself to be built, so in order to cross-compile
# Python, we need to build a host Python first. This host Python is
# also installed in $(HOST_DIR), as it is needed when cross-compiling
# third-party Python modules.

HOST_PYTHON_CONF_OPT += 	\
	--enable-static		\
	--without-cxx-main 	\
	--disable-sqlite3	\
	--disable-tk		\
	--with-expat=system	\
	--disable-curses	\
	--disable-codecs-cjk	\
	--disable-nis		\
	--enable-unicodedata	\
	--disable-dbm		\
	--disable-gdbm		\
	--disable-bsddb		\
	--disable-test-modules	\
	--disable-bz2		\
	--disable-ssl		\
	--disable-pyo-build

# Make sure that LD_LIBRARY_PATH overrides -rpath.
# This is needed because libpython may be installed at the same time that
# python is called.
HOST_PYTHON_CONF_ENV += \
	LDFLAGS="$(HOST_LDFLAGS) -Wl,--enable-new-dtags"

# Building host python in parallel sometimes triggers a "Bus error"
# during the execution of "./python setup.py build" in the
# installation step. It is probably due to the installation of a
# shared library taking place in parallel to the execution of
# ./python, causing spurious Bus error. Building host-python with
# MAKE1 has shown to workaround the problem.
HOST_PYTHON_MAKE = $(MAKE1)

PYTHON_DEPENDENCIES  = host-python libffi

HOST_PYTHON_DEPENDENCIES = host-expat host-zlib

PYTHON_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_PYTHON_READLINE),y)
PYTHON_DEPENDENCIES += readline
endif

ifeq ($(BR2_PACKAGE_PYTHON_CURSES),y)
PYTHON_DEPENDENCIES += ncurses
else
PYTHON_CONF_OPT += --disable-curses
endif

ifeq ($(BR2_PACKAGE_PYTHON_PYEXPAT),y)
PYTHON_DEPENDENCIES += expat
PYTHON_CONF_OPT += --with-expat=system
else
PYTHON_CONF_OPT += --with-expat=none
endif

ifeq ($(BR2_PACKAGE_PYTHON_BSDDB),y)
PYTHON_DEPENDENCIES += berkeleydb
else
PYTHON_CONF_OPT += --disable-bsddb
endif

ifeq ($(BR2_PACKAGE_PYTHON_SQLITE),y)
PYTHON_DEPENDENCIES += sqlite
else
PYTHON_CONF_OPT += --disable-sqlite3
endif

ifeq ($(BR2_PACKAGE_PYTHON_SSL),y)
PYTHON_DEPENDENCIES += openssl
else
PYTHON_CONF_OPT += --disable-ssl
endif

ifneq ($(BR2_PACKAGE_PYTHON_CODECSCJK),y)
PYTHON_CONF_OPT += --disable-codecs-cjk
endif

ifneq ($(BR2_PACKAGE_PYTHON_UNICODEDATA),y)
PYTHON_CONF_OPT += --disable-unicodedata
endif

# Default is UCS2 w/o a conf opt
ifeq ($(BR2_PACKAGE_PYTHON_UCS4),y)
PYTHON_CONF_OPT += --enable-unicode=ucs4
endif

ifeq ($(BR2_PACKAGE_PYTHON_BZIP2),y)
PYTHON_DEPENDENCIES += bzip2
else
PYTHON_CONF_OPT += --disable-bz2
endif

ifeq ($(BR2_PACKAGE_PYTHON_ZLIB),y)
PYTHON_DEPENDENCIES += zlib
else
PYTHON_CONF_OPT += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_PYTHON_HASHLIB),y)
PYTHON_DEPENDENCIES += openssl
endif

PYTHON_CONF_ENV += \
	ac_cv_have_long_long_format=yes \
	ac_cv_file__dev_ptmx=yes \
	ac_cv_file__dev_ptc=yes \
	ac_cv_working_tzset=yes

PYTHON_CONF_OPT += \
	--without-cxx-main 	\
	--without-doc-strings	\
	--with-system-ffi	\
	--disable-pydoc		\
	--disable-test-modules	\
	--disable-lib2to3	\
	--disable-gdbm		\
	--disable-tk		\
	--disable-nis		\
	--disable-dbm		\
	--disable-pyo-build

# This is needed to make sure the Python build process doesn't try to
# regenerate those files with the pgen program. Otherwise, it builds
# pgen for the target, and tries to run it on the host.

define PYTHON_TOUCH_GRAMMAR_FILES
	touch $(@D)/Include/graminit.h $(@D)/Python/graminit.c
endef

PYTHON_POST_PATCH_HOOKS += PYTHON_TOUCH_GRAMMAR_FILES

#
# Remove useless files. In the config/ directory, only the Makefile
# and the pyconfig.h files are needed at runtime.
#
# idle & smtpd.py have bad shebangs and are mostly samples
#
define PYTHON_REMOVE_USELESS_FILES
	rm -f $(TARGET_DIR)/usr/bin/python$(PYTHON_VERSION_MAJOR)-config
	rm -f $(TARGET_DIR)/usr/bin/python2-config
	rm -f $(TARGET_DIR)/usr/bin/python-config
	rm -f $(TARGET_DIR)/usr/bin/smtpd.py
	for i in `find $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/config/ \
		-type f -not -name pyconfig.h -a -not -name Makefile` ; do \
		rm -f $$i ; \
	done
endef

PYTHON_POST_INSTALL_TARGET_HOOKS += PYTHON_REMOVE_USELESS_FILES

#
# Make sure libpython gets stripped out on target
#
define PYTHON_ENSURE_LIBPYTHON_STRIPPED
	chmod u+w $(TARGET_DIR)/usr/lib/libpython$(PYTHON_VERSION_MAJOR)*.so
endef

PYTHON_POST_INSTALL_TARGET_HOOKS += PYTHON_ENSURE_LIBPYTHON_STRIPPED

# Always install the python symlink in the target tree
define PYTHON_INSTALL_TARGET_PYTHON_SYMLINK
	ln -sf python2 $(TARGET_DIR)/usr/bin/python
endef

PYTHON_POST_INSTALL_TARGET_HOOKS += PYTHON_INSTALL_TARGET_PYTHON_SYMLINK

# Always install the python-config symlink in the staging tree
define PYTHON_INSTALL_STAGING_PYTHON_CONFIG_SYMLINK
	ln -sf python2-config $(STAGING_DIR)/usr/bin/python-config
endef

PYTHON_POST_INSTALL_STAGING_HOOKS += PYTHON_INSTALL_STAGING_PYTHON_CONFIG_SYMLINK

PYTHON_AUTORECONF = YES

# Some packages may have build scripts requiring python2.
# Only install the python symlink in the host tree if python3 is not enabled
# for the target, otherwise the default python program may be missing.
ifneq ($(BR2_PACKAGE_PYTHON3),y)
define HOST_PYTHON_INSTALL_PYTHON_SYMLINK
	ln -sf python2 $(HOST_DIR)/usr/bin/python
	ln -sf python2-config $(HOST_DIR)/usr/bin/python-config
endef

HOST_PYTHON_POST_INSTALL_HOOKS += HOST_PYTHON_INSTALL_PYTHON_SYMLINK
endif

# Provided to other packages
PYTHON_PATH = $(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/sysconfigdata/:$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages/

$(eval $(autotools-package))
$(eval $(host-autotools-package))
