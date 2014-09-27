################################################################################
#
# harfbuzz
#
################################################################################

HARFBUZZ_VERSION = 0.9.22
HARFBUZZ_SITE = http://www.freedesktop.org/software/harfbuzz/release
HARFBUZZ_SOURCE = harfbuzz-$(HARFBUZZ_VERSION).tar.bz2
HARFBUZZ_LICENSE = MIT, ISC (ucdn library)
HARFBUZZ_LICENSE_FILES = COPYING src/hb-ucdn/COPYING
HARFBUZZ_INSTALL_STAGING = YES

HARFBUZZ_CONF_OPTS = --without-coretext --without-uniscribe --without-graphite2

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
# forgets to link test programs with -pthread breaking static link
HARFBUZZ_CONF_ENV = LDFLAGS="$(TARGET_LDFLAGS) -pthread"
endif

ifeq ($(BR2_PACKAGE_CAIRO),y)
	HARFBUZZ_DEPENDENCIES += cairo
	HARFBUZZ_CONF_OPTS += --with-cairo=yes
else
	HARFBUZZ_CONF_OPTS += --with-cairo=no
endif

ifeq ($(BR2_PACKAGE_FREETYPE),y)
	HARFBUZZ_DEPENDENCIES += freetype
	HARFBUZZ_CONF_OPTS += --with-freetype=yes
else
	HARFBUZZ_CONF_OPTS += --with-freetype=no
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
	HARFBUZZ_DEPENDENCIES += libglib2
	HARFBUZZ_CONF_OPTS += --with-glib=yes
else
	HARFBUZZ_CONF_OPTS += --with-glib=no
endif

ifeq ($(BR2_PACKAGE_ICU),y)
	HARFBUZZ_DEPENDENCIES += icu
	HARFBUZZ_CONF_OPTS += --with-icu=yes
else
	HARFBUZZ_CONF_OPTS += --with-icu=no
endif

$(eval $(autotools-package))
