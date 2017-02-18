################################################################################
#
# civetweb
#
################################################################################

CIVETWEB_VERSION = v1.5
CIVETWEB_SITE = $(call github,sunsetbrew,civetweb,$(CIVETWEB_VERSION))
CIVETWEB_LICENSE = MIT
CIVETWEB_LICENSE_FILES = LICENSE.md

CIVETWEB_CONF_OPTS = TARGET_OS=LINUX WITH_IPV6=1
CIVETWEB_COPT = -DHAVE_POSIX_FALLOCATE=0
CIVETWEB_LIBS = -lpthread -lm
CIVETWEB_SYSCONFDIR = /etc
CIVETWEB_HTMLDIR = /var/www

ifeq ($(BR2_PACKAGE_CIVETWEB_WITH_LUA),y)
CIVETWEB_CONF_OPTS += WITH_LUA=1
CIVETWEB_LIBS += -ldl
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
CIVETWEB_COPT += -DNO_SSL_DL
CIVETWEB_LIBS += -lssl -lcrypto -lz
CIVETWEB_DEPENDENCIES += openssl
else
CIVETWEB_COPT += -DNO_SSL
endif

define CIVETWEB_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) build \
		$(CIVETWEB_CONF_OPTS) \
		COPT="$(CIVETWEB_COPT)" LIBS="$(CIVETWEB_LIBS)"
endef

define CIVETWEB_INSTALL_TARGET_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D) install \
		DOCUMENT_ROOT="$(CIVETWEB_HTMLDIR)" \
		CONFIG_FILE2="$(CIVETWEB_SYSCONFDIR)/civetweb.conf" \
		HTMLDIR="$(TARGET_DIR)$(CIVETWEB_HTMLDIR)" \
		SYSCONFDIR="$(TARGET_DIR)$(CIVETWEB_SYSCONFDIR)" \
		PREFIX="$(TARGET_DIR)/usr" \
		$(CIVETWEB_CONF_OPTS) \
		COPT='$(CIVETWEB_COPT)'
endef

$(eval $(generic-package))
