################################################################################
#
# minissdpd
#
################################################################################

MINISSDPD_VERSION = 1.5.20180223
MINISSDPD_SITE = http://miniupnp.free.fr/files
MINISSDPD_LICENSE = BSD-3-Clause
MINISSDPD_LICENSE_FILES = LICENSE
MINISSDPD_DEPENDENCIES = libnfnetlink

define MINISSDPD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) -D_GNU_SOURCE" \
		-C $(@D)
endef

define MINISSDPD_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		PREFIX=$(TARGET_DIR) install
endef

# Use dedicated init scripts for systemV and systemd instead of using
# minissdpd.init.d.script as it is not compatible with buildroot init system
define MINISSDPD_INSTALL_INIT_SYSV
	$(RM) $(TARGET_DIR)/etc/init.d/minissdpd
	$(INSTALL) -D -m 0755 package/minissdpd/S50minissdpd \
		$(TARGET_DIR)/etc/init.d/S50minissdpd
endef

define MINISSDPD_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/minissdpd/minissdpd.service \
		$(TARGET_DIR)/usr/lib/systemd/system/minissdpd.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -sf ../../../../usr/lib/systemd/system/minissdpd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/minissdpd.service
endef

$(eval $(generic-package))
