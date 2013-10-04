################################################################################
#
# python
#
################################################################################

PYTHON_VERSION_MAJOR = 2.7
PYTHON_VERSION       = $(PYTHON_VERSION_MAJOR).3
PYTHON_SOURCE        = Python-$(PYTHON_VERSION).tar.xz
PYTHON_SITE          = http://python.org/ftp/python/$(PYTHON_VERSION)
PYTHON_LICENSE       = Python software foundation license v2, others
PYTHON_LICENSE_FILES = LICENSE

# Python needs itself and a "pgen" program to build itself, both being
# provided in the Python sources. So in order to cross-compile Python,
# we need to build a host Python first. This host Python is also
# installed in $(HOST_DIR), as it is needed when cross-compiling
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
	--disable-unicodedata	\
	--disable-dbm		\
	--disable-gdbm		\
	--disable-bsddb		\
	--disable-test-modules	\
	--disable-bz2		\
	--disable-ssl

HOST_PYTHON_MAKE_ENV = \
	PYTHON_MODULES_INCLUDE=$(HOST_DIR)/usr/include \
	PYTHON_MODULES_LIB="$(HOST_DIR)/lib $(HOST_DIR)/usr/lib"


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
	PYTHON_FOR_BUILD=$(HOST_PYTHON_DIR)/python \
	PGEN_FOR_BUILD=$(HOST_PYTHON_DIR)/Parser/pgen \
	ac_cv_have_long_long_format=yes

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
	--disable-dbm

PYTHON_MAKE_ENV = \
	PYTHON_MODULES_INCLUDE=$(STAGING_DIR)/usr/include \
	PYTHON_MODULES_LIB="$(STAGING_DIR)/lib $(STAGING_DIR)/usr/lib"

# python distutils adds -L$LIBDIR when linking binary extensions, causing
# trouble for cross compilation
define PYTHON_FIXUP_LIBDIR
	$(SED) 's|^LIBDIR=.*|LIBDIR= $(STAGING_DIR)/usr/lib|' \
	   $(STAGING_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/config/Makefile
endef

PYTHON_POST_INSTALL_STAGING_HOOKS += PYTHON_FIXUP_LIBDIR

#
# Remove useless files. In the config/ directory, only the Makefile
# and the pyconfig.h files are needed at runtime.
#
# idle & smtpd.py have bad shebangs and are mostly samples
#
define PYTHON_REMOVE_USELESS_FILES
	rm -f $(TARGET_DIR)/usr/bin/idle
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

PYTHON_AUTORECONF = YES

$(eval $(autotools-package))
$(eval $(host-autotools-package))
