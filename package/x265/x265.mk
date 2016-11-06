################################################################################
#
# x265
#
################################################################################

X265_VERSION = 1.9
X265_SOURCE = x265_$(X265_VERSION).tar.gz
X265_SITE = https://bitbucket.org/multicoreware/x265/downloads
X265_LICENSE = GPLv2+
X265_LICENSE_FILES = COPYING
X265_SUBDIR = source
X265_INSTALL_STAGING = YES

ifeq ($(BR2_i386)$(BR2_x86_64),y)
X265_DEPENDENCIES += host-yasm
endif

ifeq ($(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
X265_CONF_OPTS += -DENABLE_SHARED=ON -DENABLE_PIC=ON
else
X265_CONF_OPTS += -DENABLE_SHARED=OFF
endif

ifeq ($(BR2_PACKAGE_X265_CLI),y)
X265_CONF_OPTS += -DENABLE_CLI=ON
else
X265_CONF_OPTS += -DENABLE_CLI=OFF
endif

$(eval $(cmake-package))
