################################################################################
#
# lzo
#
################################################################################

LZO_VERSION = 2.10
LZO_SITE = http://www.oberhumer.com/opensource/lzo/download
LZO_LICENSE = GPL-2.0+
LZO_LICENSE_FILES = COPYING
LZO_INSTALL_STAGING = YES
LZO_SUPPORTS_IN_SOURCE_BUILD = NO

ifeq ($(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
LZO_CONF_OPTS += -DENABLE_SHARED=ON
else
LZO_CONF_OPTS += -DENABLE_SHARED=OFF
endif

ifeq ($(BR2_STATIC_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
LZO_CONF_OPTS += -DENABLE_STATIC=ON
else
LZO_CONF_OPTS += -DENABLE_STATIC=OFF
endif

$(eval $(cmake-package))
$(eval $(host-cmake-package))
