################################################################################
#
# sslh
#
################################################################################

SSLH_VERSION = 1.20
SSLH_SOURCE = sslh-v$(SSLH_VERSION).tar.gz
SSLH_SITE = http://www.rutschle.net/tech/sslh
SSLH_LICENSE = GPL-2.0+
SSLH_LICENSE_FILES = COPYING

SSLH_DEPENDENCIES = libconfig

SSLH_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS)

ifeq ($(BR2_PACKAGE_LIBCAP),y)
SSLH_DEPENDENCIES += libcap
SSLH_MAKE_OPTS += USELIBCAP=1
else
SSLH_MAKE_OPTS += USELIBCAP=
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
SSLH_DEPENDENCIES += pcre
SSLH_MAKE_OPTS += USELIBPCRE=1
else
SSLH_MAKE_OPTS += USELIBPCRE=
endif

ifeq ($(BR2_PACKAGE_SYSTEMD),y)
SSLH_DEPENDENCIES += systemd
SSLH_MAKE_OPTS += USESYSTEMD=1
else
SSLH_MAKE_OPTS += USESYSTEMD=
endif

define SSLH_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(SSLH_MAKE_OPTS) -C $(@D)
endef

define SSLH_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(SSLH_MAKE_OPTS) -C $(@D) \
		DESTDIR=$(TARGET_DIR) install
endef

define SSLH_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/sslh/S35sslh $(TARGET_DIR)/etc/init.d/S35sslh
endef

$(eval $(generic-package))
