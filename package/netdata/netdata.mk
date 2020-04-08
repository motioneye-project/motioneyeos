################################################################################
#
# netdata
#
################################################################################

NETDATA_VERSION = 1.21.0
NETDATA_SITE = $(call github,netdata,netdata,v$(NETDATA_VERSION))
NETDATA_LICENSE = GPL-3.0+
NETDATA_LICENSE_FILES = LICENSE
# netdata's source code is released without a generated configure script
NETDATA_AUTORECONF = YES
NETDATA_CONF_OPTS = --disable-dbengine
NETDATA_DEPENDENCIES = libuv util-linux zlib

ifeq ($(BR2_GCC_ENABLE_LTO),y)
NETDATA_CONF_OPTS += --enable-lto
else
NETDATA_CONF_OPTS += --disable-lto
endif

ifeq ($(BR2_PACKAGE_CUPS),y)
NETDATA_CONF_OPTS += --enable-plugin-cups
NETDATA_DEPENDENCIES += cups
else
NETDATA_CONF_OPTS += --disable-plugin-cups
endif

ifeq ($(BR2_PACKAGE_JSON_C),y)
NETDATA_CONF_OPTS += --enable-jsonc
NETDATA_DEPENDENCIES += json-c
else
NETDATA_CONF_OPTS += --disable-jsonc
endif

ifeq ($(BR2_PACKAGE_NFACCT),y)
NETDATA_CONF_OPTS += --enable-plugin-nfacct
NETDATA_DEPENDENCIES += nfacct
else
NETDATA_CONF_OPTS += --disable-plugin-nfacct
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
NETDATA_CONF_OPTS += --enable-https
NETDATA_DEPENDENCIES += openssl
else
NETDATA_CONF_OPTS += --disable-https
endif

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
NETDATA_CONF_ENV += LIBS=-latomic
endif

define NETDATA_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/netdata/S60netdata \
		$(TARGET_DIR)/etc/init.d/S60netdata
endef

$(eval $(autotools-package))
