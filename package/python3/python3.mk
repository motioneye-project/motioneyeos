################################################################################
#
# python3
#
################################################################################

PYTHON3_VERSION_MAJOR = 3.4
PYTHON3_VERSION_MINOR = 0
PYTHON3_VERSION       = $(PYTHON3_VERSION_MAJOR).$(PYTHON3_VERSION_MINOR)rc1
PYTHON3_SOURCE        = Python-$(PYTHON3_VERSION).tar.xz
PYTHON3_SITE          = http://python.org/ftp/python/$(PYTHON3_VERSION_MAJOR).$(PYTHON3_VERSION_MINOR)

# Python needs itself and a "pgen" program to build itself, both being
# provided in the Python sources. So in order to cross-compile Python,
# we need to build a host Python first. This host Python is also
# installed in $(HOST_DIR), as it is needed when cross-compiling
# third-party Python modules.

HOST_PYTHON3_CONF_OPT += 	\
	--without-ensurepip	\
	--without-cxx-main 	\
	--disable-sqlite3	\
	--disable-tk		\
	--with-expat=system	\
	--disable-curses	\
	--disable-codecs-cjk	\
	--disable-nis		\
	--enable-unicodedata	\
	--disable-test-modules	\
	--disable-idle3		\
	--disable-pyo-build

PYTHON3_DEPENDENCIES  = host-python3 libffi

HOST_PYTHON3_DEPENDENCIES = host-expat host-zlib

PYTHON3_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_PYTHON3_READLINE),y)
PYTHON3_DEPENDENCIES += readline
endif

ifeq ($(BR2_PACKAGE_PYTHON3_CURSES),y)
PYTHON3_DEPENDENCIES += ncurses
else
PYTHON3_CONF_OPT += --disable-curses
endif

ifeq ($(BR2_PACKAGE_PYTHON3_PYEXPAT),y)
PYTHON3_DEPENDENCIES += expat
PYTHON3_CONF_OPT += --with-expat=system
else
PYTHON3_CONF_OPT += --with-expat=none
endif

ifeq ($(BR2_PACKAGE_PYTHON3_PYC_ONLY),y)
PYTHON3_CONF_OPT += --enable-old-stdlib-cache
endif

ifeq ($(BR2_PACKAGE_PYTHON3_PY_ONLY),y)
PYTHON3_CONF_OPT += --disable-pyc-build
endif

ifeq ($(BR2_PACKAGE_PYTHON3_SQLITE),y)
PYTHON3_DEPENDENCIES += sqlite
else
PYTHON3_CONF_OPT += --disable-sqlite3
endif

ifeq ($(BR2_PACKAGE_PYTHON3_SSL),y)
PYTHON3_DEPENDENCIES += openssl
endif

ifneq ($(BR2_PACKAGE_PYTHON3_CODECSCJK),y)
PYTHON3_CONF_OPT += --disable-codecs-cjk
endif

ifneq ($(BR2_PACKAGE_PYTHON3_UNICODEDATA),y)
PYTHON3_CONF_OPT += --disable-unicodedata
endif

ifeq ($(BR2_PACKAGE_PYTHON3_BZIP2),y)
PYTHON3_DEPENDENCIES += bzip2
endif

ifeq ($(BR2_PACKAGE_PYTHON3_ZLIB),y)
PYTHON3_DEPENDENCIES += zlib
endif

PYTHON3_CONF_ENV += \
	ac_cv_have_long_long_format=yes \
	ac_cv_file__dev_ptmx=yes \
	ac_cv_file__dev_ptc=yes \

PYTHON3_CONF_OPT += \
	--without-ensurepip	\
	--without-cxx-main 	\
	--with-system-ffi	\
	--disable-pydoc		\
	--disable-test-modules	\
	--disable-lib2to3	\
	--disable-tk		\
	--disable-nis		\
	--disable-idle3		\
	--disable-pyo-build

# This is needed to make sure the Python build process doesn't try to
# regenerate those files with the pgen program. Otherwise, it builds
# pgen for the target, and tries to run it on the host.

define PYTHON3_TOUCH_GRAMMAR_FILES
	touch $(@D)/Include/graminit.h $(@D)/Python/graminit.c
endef

PYTHON3_POST_PATCH_HOOKS += PYTHON3_TOUCH_GRAMMAR_FILES

#
# Remove useless files. In the config/ directory, only the Makefile
# and the pyconfig.h files are needed at runtime.
#
define PYTHON3_REMOVE_USELESS_FILES
	rm -f $(TARGET_DIR)/usr/bin/python$(PYTHON3_VERSION_MAJOR)-config
	rm -f $(TARGET_DIR)/usr/bin/python$(PYTHON3_VERSION_MAJOR)m-config
	rm -f $(TARGET_DIR)/usr/bin/python3-config
	rm -f $(TARGET_DIR)/usr/bin/smtpd.py.3
	for i in `find $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/config-$(PYTHON3_VERSION_MAJOR)m/ \
		-type f -not -name pyconfig.h -a -not -name Makefile` ; do \
		rm -f $$i ; \
	done
endef

PYTHON3_POST_INSTALL_TARGET_HOOKS += PYTHON3_REMOVE_USELESS_FILES

PYTHON3_AUTORECONF = YES

define PYTHON3_INSTALL_SYMLINK
	ln -fs python3 $(TARGET_DIR)/usr/bin/python
endef

ifneq ($(BR2_PACKAGE_PYTHON),y)
PYTHON3_POST_INSTALL_TARGET_HOOKS += PYTHON3_INSTALL_SYMLINK
endif

define HOST_PYTHON3_INSTALL_SYMLINK
	ln -fs python3 $(HOST_DIR)/usr/bin/python
endef

HOST_PYTHON3_POST_INSTALL_HOOKS += HOST_PYTHON3_INSTALL_SYMLINK

# Provided to other packages
PYTHON3_PATH = $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/sysconfigdata/:$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages/

$(eval $(autotools-package))
$(eval $(host-autotools-package))
