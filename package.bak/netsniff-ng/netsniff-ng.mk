################################################################################
#
# netsniff-ng
#
################################################################################

NETSNIFF_NG_VERSION = v0.6.2
NETSNIFF_NG_SITE = $(call github,netsniff-ng,netsniff-ng,$(NETSNIFF_NG_VERSION))
NETSNIFF_NG_LICENSE = GPLv2
NETSNIFF_NG_LICENSE_FILES = README COPYING
# Prevent netsniff-ng configure script from finding a host installed nacl
NETSNIFF_NG_CONF_ENV = \
	NACL_INC_DIR=/dev/null \
	NACL_LIB_DIR=/dev/null
NETSNIFF_NG_DEPENDENCIES = \
	libnl libpcap libcli libnetfilter_conntrack \
	liburcu libnet

ifeq ($(BR2_PACKAGE_GEOIP),y)
NETSNIFF_NG_DEPENDENCIES += geoip
endif

ifeq ($(BR2_PACKAGE_NCURSES),y)
NETSNIFF_NG_DEPENDENCIES += ncurses
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
NETSNIFF_NG_DEPENDENCIES += zlib
endif

# hand-written configure script and makefile
define NETSNIFF_NG_CONFIGURE_CMDS
	(cd $(@D); \
		$(NETSNIFF_NG_CONF_ENV) \
		$(TARGET_CONFIGURE_ARGS) \
		$(TARGET_CONFIGURE_OPTS) \
		./configure \
		--prefix=$(TARGET_DIR)/usr \
	)
endef

define NETSNIFF_NG_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define NETSNIFF_NG_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		PREFIX=$(TARGET_DIR)/usr ETCDIR=$(TARGET_DIR)/etc install -C $(@D)
endef

$(eval $(generic-package))
