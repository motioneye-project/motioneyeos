################################################################################
#
# elfutils
#
################################################################################

ELFUTILS_VERSION = 0.174
ELFUTILS_SOURCE = elfutils-$(ELFUTILS_VERSION).tar.bz2
ELFUTILS_SITE = https://sourceware.org/elfutils/ftp/$(ELFUTILS_VERSION)
ELFUTILS_INSTALL_STAGING = YES
ELFUTILS_LICENSE = GPL-2.0+ or LGPL-3.0+ (library)
ELFUTILS_LICENSE_FILES = COPYING COPYING-GPLV2 COPYING-LGPLV3
ELFUTILS_DEPENDENCIES = zlib $(TARGET_NLS_DEPENDENCIES)
HOST_ELFUTILS_DEPENDENCIES = host-zlib host-bzip2 host-xz

# We patch configure.ac
ELFUTILS_AUTORECONF = YES
HOST_ELFUTILS_AUTORECONF = YES

# Pass a custom program prefix to avoid a naming conflict between
# elfutils binaries and binutils binaries.
ELFUTILS_CONF_OPTS += \
	--program-prefix="eu-"

HOST_ELFUTILS_CONF_OPTS = \
	--with-bzlib \
	--with-lzma \
	--disable-progs

# elfutils gets confused when lfs mode is forced, so don't
ELFUTILS_CFLAGS = $(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CFLAGS))
ELFUTILS_CPPFLAGS = $(filter-out -D_FILE_OFFSET_BITS=64,$(TARGET_CPPFLAGS))

# sparc64 needs -fPIC instead of -fpic
ifeq ($(BR2_sparc64),y)
ELFUTILS_CFLAGS += -fPIC
endif

ELFUTILS_CONF_ENV += \
	CFLAGS="$(ELFUTILS_CFLAGS)" \
	CPPFLAGS="$(ELFUTILS_CPPFLAGS)"

ELFUTILS_LDFLAGS = $(TARGET_LDFLAGS) \
	$(TARGET_NLS_LIBS)

ELFUTILS_CONF_ENV += \
	LDFLAGS="$(ELFUTILS_LDFLAGS)"

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
ELFUTILS_DEPENDENCIES += argp-standalone
ELFUTILS_CONF_OPTS += --disable-symbol-versioning
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
ELFUTILS_LICENSE := $(ELFUTILS_LICENSE), GPL-3.0+ (programs)
ELFUTILS_LICENSE_FILES += COPYING
else
ELFUTILS_CONF_OPTS += --disable-progs
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
