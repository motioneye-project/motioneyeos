################################################################################
#
# mp4v2
#
################################################################################

MP4V2_VERSION = 2.0.0
MP4V2_SOURCE = mp4v2-$(MP4V2_VERSION).tar.bz2
MP4V2_SITE = https://mp4v2.googlecode.com/files
MP4V2_INSTALL_STAGING = YES
MP4V2_LICENSE = MPLv1.1
MP4V2_LICENSE_FILES = COPYING

ifeq ($(BR2_LARGEFILE),y)
MP4V2_CONF_OPTS += --enable-largefile
else
MP4V2_CONF_OPTS += --disable-largefile
endif

ifeq ($(BR2_PACKAGE_MP4V2_UTIL),y)
MP4V2_CONF_OPTS += --enable-util
else
MP4V2_CONF_OPTS += --disable-util
endif

$(eval $(autotools-package))
