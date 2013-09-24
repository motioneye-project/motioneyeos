################################################################################
#
# civetweb
#
################################################################################

CIVETWEB_VERSION = 1.3
CIVETWEB_SITE = http://github.com/sunsetbrew/civetweb/tarball/v$(CIVETWEB_VERSION)
CIVETWEB_LICENSE = MIT
CIVETWEB_LICENSE_FILES = LICENSE.md

CIVETWEB_CONF_OPT = TARGET_OS=LINUX
CIVETWEB_COPT = $(TARGET_CFLAGS) -DHAVE_POSIX_FALLOCATE=0
CIVETWEB_LIBS = -lpthread -lm -ldl
CIVETWEB_SYSCONFDIR = /etc
CIVETWEB_HTMLDIR = /var/www

ifneq ($(BR2_LARGEFILE),y)
	CIVETWEB_COPT += -DSQLITE_DISABLE_LFS
endif

ifeq ($(BR2_INET_IPV6),y)
	CIVETWEB_CONF_OPT += WITH_IPV6=1
endif

ifeq ($(BR2_CIVETWEB_WITH_LUA),y)
	CIVETWEB_CONF_OPT += WITH_LUA=1
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
	CIVETWEB_COPT += -DNO_SSL_DL
	CIVETWEB_LIBS += -lssl -lcrypto -lz
	CIVETWEB_DEPENDENCIES += openssl
else
	CIVETWEB_COPT += -DNO_SSL
endif

define CIVETWEB_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" LDFLAGS="$(TARGET_LDFLAGS)" -C $(@D) build \
		$(CIVETWEB_CONF_OPT) \
		COPT="$(CIVETWEB_COPT)" LIBS="$(CIVETWEB_LIBS)"
endef

define CIVETWEB_INSTALL_TARGET_CMDS
	$(MAKE) CC="$(TARGET_CC)" -C $(@D) install \
		DOCUMENT_ROOT="$(CIVETWEB_HTMLDIR)" \
		CONFIG_FILE2="$(CIVETWEB_SYSCONFDIR)/civetweb.conf" \
		HTMLDIR="$(TARGET_DIR)$(CIVETWEB_HTMLDIR)" \
		SYSCONFDIR="$(TARGET_DIR)$(CIVETWEB_SYSCONFDIR)" \
		PREFIX="$(TARGET_DIR)/usr" \
		$(CIVETWEB_CONF_OPT) \
		COPT='$(CIVETWEB_COPT)'
endef

$(eval $(generic-package))

