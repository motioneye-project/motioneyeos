################################################################################
#
# linux-pam
#
################################################################################

LINUX_PAM_VERSION = 1.3.0
LINUX_PAM_SOURCE = Linux-PAM-$(LINUX_PAM_VERSION).tar.bz2
LINUX_PAM_SITE = http://linux-pam.org/library
LINUX_PAM_INSTALL_STAGING = YES
LINUX_PAM_CONF_OPTS = \
	--disable-prelude \
	--disable-isadir \
	--disable-nis \
	--disable-db \
	--disable-regenerate-docu \
	--enable-securedir=/lib/security \
	--libdir=/lib
LINUX_PAM_DEPENDENCIES = flex host-flex host-pkgconf
LINUX_PAM_AUTORECONF = YES
LINUX_PAM_LICENSE = BSD-3c
LINUX_PAM_LICENSE_FILES = Copyright

ifeq ($(BR2_NEEDS_GETTEXT_IF_LOCALE),y)
LINUX_PAM_DEPENDENCIES += gettext
LINUX_PAM_MAKE_OPTS += LIBS=-lintl
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
LINUX_PAM_CONF_OPTS += --enable-selinux
LINUX_PAM_DEPENDENCIES += libselinux
define LINUX_PAM_SELINUX_PAMFILE_TWEAK
	$(SED) 's/^# \(.*pam_selinux.so.*\)$$/\1/' \
		$(TARGET_DIR)/etc/pam.d/login
endef
else
LINUX_PAM_CONF_OPTS += --disable-selinux
endif

ifeq ($(BR2_PACKAGE_AUDIT),y)
LINUX_PAM_CONF_OPTS += --enable-audit
LINUX_PAM_DEPENDENCIES += audit
else
LINUX_PAM_CONF_OPTS += --disable-audit
endif

# Install default pam config (deny everything except login)
define LINUX_PAM_INSTALL_CONFIG
	$(INSTALL) -m 0644 -D package/linux-pam/login.pam \
		$(TARGET_DIR)/etc/pam.d/login
	$(INSTALL) -m 0644 -D package/linux-pam/other.pam \
		$(TARGET_DIR)/etc/pam.d/other
	$(LINUX_PAM_SELINUX_PAMFILE_TWEAK)
endef

LINUX_PAM_POST_INSTALL_TARGET_HOOKS += LINUX_PAM_INSTALL_CONFIG

$(eval $(autotools-package))
