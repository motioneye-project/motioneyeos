################################################################################
#
# xlib_libXfont
#
################################################################################

XLIB_LIBXFONT_VERSION = 1.5.2
XLIB_LIBXFONT_SOURCE = libXfont-$(XLIB_LIBXFONT_VERSION).tar.bz2
XLIB_LIBXFONT_SITE = http://xorg.freedesktop.org/releases/individual/lib
XLIB_LIBXFONT_LICENSE = MIT
XLIB_LIBXFONT_LICENSE_FILES = COPYING
XLIB_LIBXFONT_AUTORECONF = YES
XLIB_LIBXFONT_INSTALL_STAGING = YES

XLIB_LIBXFONT_DEPENDENCIES = freetype xlib_libfontenc xlib_xtrans xproto_fontsproto xproto_xproto xfont_encodings

HOST_XLIB_LIBXFONT_DEPENDENCIES = \
	host-freetype host-xlib_libfontenc host-xlib_xtrans \
	host-xproto_fontsproto host-xproto_xproto host-xfont_encodings

XLIB_LIBXFONT_CONF_OPTS = --disable-devel-docs
HOST_XLIB_LIBXFONT_CONF_OPTS = --disable-devel-docs

ifeq ($(BR2_microblaze),y)
# The microblaze toolchains don't define the __ELF__ preprocessor
# symbol even though they do use the elf format. LibXfont checks for
# this symbol to know if weak symbols are supported, and otherwise
# falls back to emulation code using dlopen - Causing linker issues
# for stuff using libXfont.
# Work around it by defining the symbol here as well.
XLIB_LIBXFONT_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -D__ELF__"
endif

$(eval $(autotools-package))
$(eval $(host-autotools-package))
