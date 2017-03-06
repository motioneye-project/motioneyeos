################################################################################
#
# harfbuzz
#
################################################################################

HARFBUZZ_VERSION = 1.4.4
HARFBUZZ_SITE = https://www.freedesktop.org/software/harfbuzz/release
HARFBUZZ_SOURCE = harfbuzz-$(HARFBUZZ_VERSION).tar.bz2
HARFBUZZ_LICENSE = MIT, ISC (ucdn library)
HARFBUZZ_LICENSE_FILES = COPYING src/hb-ucdn/COPYING
HARFBUZZ_INSTALL_STAGING = YES
HARFBUZZ_CONF_OPTS = --with-coretext=no --with-uniscribe=no

# freetype & glib2 support required by host-pango
HOST_HARFBUZZ_DEPENDENCIES = \
	host-freetype \
	host-libglib2
HOST_HARFBUZZ_CONF_OPTS = \
	--with-coretext=no \
	--with-uniscribe=no \
	--with-graphite2=no \
	--with-cairo=no \
	--with-icu=no \
	--with-freetype=yes \
	--with-glib=yes

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

ifeq ($(BR2_PACKAGE_GRAPHITE2),y)
HARFBUZZ_DEPENDENCIES += graphite2
HARFBUZZ_CONF_OPTS += --with-graphite2=yes
else
HARFBUZZ_CONF_OPTS += --with-graphite2=no
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
$(eval $(host-autotools-package))
