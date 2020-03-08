################################################################################
#
# ser2net
#
################################################################################

SER2NET_VERSION = 4.1.1
SER2NET_SITE = http://downloads.sourceforge.net/project/ser2net/ser2net
SER2NET_LICENSE = GPL-2.0+
SER2NET_LICENSE_FILES = COPYING
SER2NET_DEPENDENCIES = gensio libyaml

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
SER2NET_CONF_OPTS += --with-pthreads
else
SER2NET_CONF_OPTS += --without-pthreads
endif

# fix gensio detection with openssl enabled
ifeq ($(BR2_PACKAGE_OPENSSL),y)
SER2NET_CONF_ENV += LIBS="`$(PKG_CONFIG_HOST_BINARY) --libs openssl`"
endif

define SER2NET_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/ser2net/S50ser2net \
		$(TARGET_DIR)/etc/init.d/S50ser2net
endef

$(eval $(autotools-package))
