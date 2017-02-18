################################################################################
#
# elfutils
#
################################################################################

ELFUTILS_VERSION = 0.161
ELFUTILS_SOURCE = elfutils-$(ELFUTILS_VERSION).tar.bz2
ELFUTILS_SITE = https://fedorahosted.org/releases/e/l/elfutils/$(ELFUTILS_VERSION)
ELFUTILS_INSTALL_STAGING = YES
ELFUTILS_LICENSE = GPLv3, GPLv2, LGPLv3
ELFUTILS_LICENSE_FILES = COPYING COPYING-GPLV2 COPYING-LGPLV3
ELFUTILS_PATCH = elfutils-portability-0.161.patch

# The tarball does not have a generated configure script
ELFUTILS_AUTORECONF = YES
ELFUTILS_CONF_OPTS += --disable-werror

ELFUTILS_CFLAGS = $(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CFLAGS))

# sparc64 needs -fPIC instead of -fpic
ifeq ($(BR2_sparc64),y)
ELFUTILS_CFLAGS += -fPIC
endif

# elfutils gets confused when lfs mode is forced, so don't
ELFUTILS_CONF_ENV += \
	CFLAGS="$(ELFUTILS_CFLAGS)" \
	CPPFLAGS="$(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CPPFLAGS))"

ELFUTILS_LDFLAGS = $(TARGET_LDFLAGS)

# Unconditionnally requires gettext.
ifeq ($(BR2_NEEDS_GETTEXT),y)
ELFUTILS_DEPENDENCIES += gettext
ELFUTILS_LDFLAGS += -lintl
endif

ELFUTILS_CONF_ENV += \
	LDFLAGS="$(ELFUTILS_LDFLAGS)"

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
ELFUTILS_DEPENDENCIES += argp-standalone
ELFUTILS_CONF_OPTS += --disable-symbol-versioning
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
ELFUTILS_DEPENDENCIES += zlib
ELFUTILS_CONF_OPTS += --with-zlib
else
ELFUTILS_CONF_OPTS += --without-zlib
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
ELFUTILS_DEPENDENCIES += bzip2
ELFUTILS_CONF_OPTS += --with-bzlib
else
ELFUTILS_CONF_OPTS += --without-bzlib
endif

ifeq ($(BR2_PACKAGE_XZ),y)
ELFUTILS_DEPENDENCIES += xz
ELFUTILS_CONF_OPTS += --with-lzma
else
ELFUTILS_CONF_OPTS += --without-lzma
endif

ifeq ($(BR2_PACKAGE_ELFUTILS_PROGS),y)
ELFUTILS_CONF_OPTS += --enable-progs
else
ELFUTILS_CONF_OPTS += --disable-progs
endif

$(eval $(autotools-package))
