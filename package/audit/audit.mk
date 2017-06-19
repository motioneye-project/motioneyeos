################################################################################
#
# audit
#
################################################################################

AUDIT_VERSION = 2.7.7
AUDIT_SITE = http://people.redhat.com/sgrubb/audit
AUDIT_LICENSE = GPL-2.0+ (programs), unclear (libraries)
AUDIT_LICENSE_FILES = COPYING

AUDIT_INSTALL_STAGING = YES

AUDIT_CONF_OPTS = --without-python --without-python3 --disable-zos-remote

ifeq ($(BR2_PACKAGE_LIBCAP_NG),y)
AUDIT_DEPENDENCIES += libcap-ng
AUDIT_CONF_OPTS += --with-libcap-ng=yes
else
AUDIT_CONF_OPTS += --with-libcap-ng=no
endif

# For i386, x86-64 and PowerPC, the system call tables are
# unconditionally included. However, for ARM(eb) and AArch64, then
# need to be explicitly enabled.

ifeq ($(BR2_arm)$(BR2_armeb),y)
AUDIT_CONF_OPTS += --with-arm
endif
ifeq ($(BR2_aarch64),y)
AUDIT_CONF_OPTS += --with-aarch64
endif

ifeq ($(BR2_INIT_SYSTEMD),y)
AUDIT_CONF_OPTS += --enable-systemd
else
AUDIT_CONF_OPTS += --disable-systemd
endif

define AUDIT_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/audit/S01auditd $(TARGET_DIR)/etc/init.d/S01auditd
endef

define AUDIT_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/auditd.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/auditd.service

	$(INSTALL) -D -m 644 package/audit/audit_tmpfiles.conf \
		$(TARGET_DIR)/usr/lib/tmpfiles.d/audit.conf
endef

define AUDIT_INSTALL_CLEANUP
	$(RM) -rf $(TARGET_DIR)/etc/rc.d
	$(RM) -rf $(TARGET_DIR)/etc/sysconfig
endef
AUDIT_POST_INSTALL_TARGET_HOOKS += AUDIT_INSTALL_CLEANUP

HOST_AUDIT_CONF_OPTS = \
	--without-python \
	--without-python3 \
	--disable-zos-remote \
	--without-libcap-ng

$(eval $(autotools-package))
$(eval $(host-autotools-package))
