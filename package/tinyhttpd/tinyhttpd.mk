################################################################################
#
# tinyhttpd
#
################################################################################

TINYHTTPD_VERSION = 0.1.0
TINYHTTPD_SITE = http://downloads.sourceforge.net/project/tinyhttpd/tinyhttpd%20source/tinyhttpd%20$(TINYHTTPD_VERSION)
TINYHTTPD_LICENSE = GPL
TINYHTTPD_LICENSE_FILES = README

define TINYHTTPD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"
endef

define TINYHTTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/httpd $(TARGET_DIR)/usr/sbin/tinyhttpd
	mkdir -p $(TARGET_DIR)/var/www
endef

define TINYHTTPD_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/tinyhttpd/S85tinyhttpd \
		$(TARGET_DIR)/etc/init.d/S85tinyhttpd
endef

define TINYHTTPD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/tinyhttpd/tinyhttpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/tinyhttpd.service
endef

$(eval $(generic-package))
