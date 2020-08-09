################################################################################
#
# chipmunk
#
################################################################################

CHIPMUNK_VERSION = 7.0.3
CHIPMUNK_SITE = https://github.com/slembcke/Chipmunk2D/archive
CHIPMUNK_SOURCE = Chipmunk-$(CHIPMUNK_VERSION).tar.gz
CHIPMUNK_INSTALL_STAGING = YES
CHIPMUNK_LICENSE = MIT
CHIPMUNK_LICENSE_FILES = LICENSE.txt
CHIPMUNK_DEPENDENCIES = libgl
CHIPMUNK_CONF_OPTS = -DBUILD_DEMOS=OFF

ifeq ($(BR2_STATIC_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
CHIPMUNK_CONF_OPTS += -DBUILD_STATIC=ON -DINSTALL_STATIC=ON
else
CHIPMUNK_CONF_OPTS += -DBUILD_STATIC=OFF -DINSTALL_STATIC=OFF
endif

ifeq ($(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),y)
CHIPMUNK_CONF_OPTS += -DBUILD_SHARED=ON
else
CHIPMUNK_CONF_OPTS += -DBUILD_SHARED=OFF
endif

$(eval $(cmake-package))
