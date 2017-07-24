################################################################################
#
# kismet
#
################################################################################

KISMET_VERSION = 2016-07-R1
KISMET_SOURCE = kismet-$(KISMET_VERSION).tar.xz
KISMET_SITE = http://www.kismetwireless.net/code
KISMET_DEPENDENCIES = host-pkgconf libpcap ncurses libnl
KISMET_CONF_OPTS += --with-netlink-version=3
KISMET_LICENSE = GPL-2.0+
KISMET_LICENSE_FILES = debian/copyright

# We touch configure.in:
KISMET_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIBCAP),y)
KISMET_DEPENDENCIES += libcap
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
KISMET_DEPENDENCIES += pcre
endif

ifeq ($(BR2_PACKAGE_KISMET_CLIENT),y)
KISMET_TARGET_BINARIES += kismet_client
endif

ifeq ($(BR2_PACKAGE_KISMET_SERVER),y)
KISMET_TARGET_BINARIES += kismet_server
KISMET_TARGET_CONFIGS += kismet.conf
endif

ifeq ($(BR2_PACKAGE_KISMET_DRONE),y)
KISMET_TARGET_BINARIES += kismet_drone
KISMET_TARGET_CONFIGS += kismet_drone.conf
endif

ifdef KISMET_TARGET_BINARIES
define KISMET_INSTALL_TARGET_BINARIES
	$(INSTALL) -m 755 $(addprefix $(KISMET_DIR)/, $(KISMET_TARGET_BINARIES)) $(TARGET_DIR)/usr/bin
endef
endif

ifdef KISMET_TARGET_CONFIGS
define KISMET_INSTALL_TARGET_CONFIGS
	$(INSTALL) -m 644 $(addprefix $(KISMET_DIR)/conf/, $(KISMET_TARGET_CONFIGS)) $(TARGET_DIR)/etc
endef
endif

define KISMET_INSTALL_TARGET_CMDS
	$(KISMET_INSTALL_TARGET_BINARIES)
	$(KISMET_INSTALL_TARGET_CONFIGS)
endef

$(eval $(autotools-package))
