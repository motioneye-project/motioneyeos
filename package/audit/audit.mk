################################################################################
#
# audit
#
################################################################################

AUDIT_VERSION = 2.4.3
AUDIT_SITE = http://people.redhat.com/sgrubb/audit/
AUDIT_LICENSE = GPLv2
AUDIT_LICENSE_FILES = COPYING

AUDIT_INSTALL_STAGING = YES

# Patching Makefile.am
AUDIT_AUTORECONF = YES

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

define AUDIT_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/audit/S01auditd $(TARGET_DIR)/etc/init.d/S01auditd
endef

define AUDIT_INSTALL_CLEANUP
	$(RM) -rf $(TARGET_DIR)/etc/rc.d
	$(RM) -rf $(TARGET_DIR)/etc/sysconfig
endef
AUDIT_POST_INSTALL_TARGET_HOOKS += AUDIT_INSTALL_CLEANUP

$(eval $(autotools-package))
