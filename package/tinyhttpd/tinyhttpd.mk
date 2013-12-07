################################################################################
#
# tinyhttpd
#
################################################################################

TINYHTTPD_VERSION = 0.1.0
TINYHTTPD_SITE = http://downloads.sourceforge.net/project/tinyhttpd/tinyhttpd%20source/tinyhttpd%20$(TINYHTTPD_VERSION)

define TINYHTTPD_BUILD_CMDS
	$(MAKE) -C $(@D) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)"
endef

define TINYHTTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/httpd $(TARGET_DIR)/usr/sbin/tinyhttpd
	$(INSTALL) -m 0755 -D package/tinyhttpd/S85tinyhttpd \
		$(TARGET_DIR)/etc/init.d/S85tinyhttpd
	mkdir -p $(TARGET_DIR)/var/www
endef

$(eval $(generic-package))
