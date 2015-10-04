################################################################################
#
# opusfile
#
################################################################################

OPUSFILE_VERSION = 0.6
OPUSFILE_SITE = http://downloads.xiph.org/releases/opus
OPUSFILE_DEPENDENCIES = host-pkgconf libogg opus
OPUSFILE_LICENSE = BSD-3c
OPUSFILE_LICENSE_FILES = COPYING
OPUSFILE_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_OPENSSL),y)
OPUSFILE_DEPENDENCIES += openssl
else
OPUSFILE_CONF_OPTS += --disable-http
endif

# Use the same as opus package since it's a dep and we can't mix
ifeq ($(BR2_PACKAGE_OPUS_FIXED_POINT),y)
OPUSFILE_CONF_OPTS += --enable-fixed-point
endif

$(eval $(autotools-package))
