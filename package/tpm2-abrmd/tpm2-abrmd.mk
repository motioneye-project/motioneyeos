################################################################################
#
# tpm2-abrmd
#
################################################################################

TPM2_ABRMD_VERSION = 2.3.0
TPM2_ABRMD_SITE = https://github.com/tpm2-software/tpm2-abrmd/releases/download/$(TPM2_ABRMD_VERSION)
TPM2_ABRMD_LICENSE = BSD-2-Clause
TPM2_ABRMD_LICENSE_FILES = LICENSE
TPM2_ABRMD_INSTALL_STAGING = YES
TPM2_ABRMD_DEPENDENCIES = libglib2 tpm2-tss host-pkgconf
TPM2_ABRMD_CONF_OPTS = \
	--disable-defaultflags \
	--with-systemdsystemunitdir=$(if $(BR2_INIT_SYSTEMD),/usr/lib/systemd/system,no) \
	--with-udevrulesdir=$(if $(BR2_PACKAGE_HAS_UDEV),/usr/lib/udev/rules.d,no)

# uses C99 code but forgets to pass -std=c99 when --disable-defaultflags is used
TPM2_ABRMD_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -std=c99"

define TPM2_ABRMD_INSTALL_INIT_SYSTEMD
	$(TARGET_MAKE_ENV) $(MAKE1) -C $(@D) DESTDIR=$(TARGET_DIR) \
		install-systemdpresetDATA install-systemdsystemunitDATA
endef

define TPM2_ABRMD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 $(TPM2_ABRMD_PKGDIR)/S80tpm2-abrmd \
		$(TARGET_DIR)/etc/init.d/S80tpm2-abrmd
endef

define TPM2_ABRMD_USERS
	tss -1 tss -1 * - - - TPM2 Access Broker & Resource Management daemon
endef

$(eval $(autotools-package))
