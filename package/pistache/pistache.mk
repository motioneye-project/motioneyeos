################################################################################
#
# pistache
#
################################################################################

PISTACHE_VERSION = 73f248acd6db4c53e6604577b7e13fd5e756f96f
PISTACHE_SITE = $(call github,oktal,pistache,$(PISTACHE_VERSION))
PISTACHE_LICENSE = Apache-2.0
PISTACHE_LICENSE_FILES = LICENSE

PISTACHE_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_OPENSSL),y)
PISTACHE_DEPENDENCIES += openssl
PISTACHE_CONF_OPTS += -DPISTACHE_USE_SSL=ON
else
PISTACHE_CONF_OPTS += -DPISTACHE_USE_SSL=OFF
endif

$(eval $(cmake-package))
