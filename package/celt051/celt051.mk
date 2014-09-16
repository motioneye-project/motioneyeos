################################################################################
#
# celt
#
################################################################################

# Although version newer than 0.5.1.3 exists, we're
# stuck with 0.5.1.3 for use by Spice (coming later)
CELT051_VERSION         = 0.5.1.3
CELT051_SOURCE          = celt-$(CELT051_VERSION).tar.gz
CELT051_SITE            = http://downloads.xiph.org/releases/celt
CELT051_LICENSE         = BSD-2c
CELT051_LICENSE_FILES   = COPYING
CELT051_INSTALL_STAGING = YES
CELT051_DEPENDENCIES    = libogg

# Need to specify --with-ogg, otherwise /usr/lib may be searched for
# if target is the same kind as host (ie. same arch, same bitness,
# same endianness, so that /usr/lib contains libraries linkable by
# our cross-compiler)
CELT051_CONF_OPT =                  \
  --enable-fixed-point              \
  --disable-fixed-point-debug       \
  --disable-experimental-postfilter \
  --disable-static-modes            \
  --disable-assertions              \
  --disable-oggtest                 \
  --with-ogg=$(STAGING_DIR)/usr     \

$(eval $(autotools-package))
