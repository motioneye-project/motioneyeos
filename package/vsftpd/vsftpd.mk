################################################################################
#
# vsftpd
#
################################################################################

VSFTPD_VERSION = 3.0.2
VSFTPD_SITE = https://security.appspot.com/downloads
VSFTPD_LIBS = -lcrypt
VSFTPD_LICENSE = GPLv2
VSFTPD_LICENSE_FILES = COPYING

define VSFTPD_DISABLE_UTMPX
	$(SED) 's/.*VSF_BUILD_UTMPX/#undef VSF_BUILD_UTMPX/' $(@D)/builddefs.h
endef

define VSFTPD_ENABLE_SSL
	$(SED) 's/.*VSF_BUILD_SSL/#define VSF_BUILD_SSL/' $(@D)/builddefs.h
endef

ifeq ($(BR2_PACKAGE_VSFTPD_UTMPX),)
VSFTPD_POST_CONFIGURE_HOOKS += VSFTPD_DISABLE_UTMPX
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
VSFTPD_DEPENDENCIES += openssl host-pkgconf
VSFTPD_LIBS += $(shell $(PKG_CONFIG_HOST_BINARY) --libs libssl libcrypto)
VSFTPD_POST_CONFIGURE_HOOKS += VSFTPD_ENABLE_SSL
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
VSFTPD_DEPENDENCIES += libcap
VSFTPD_LIBS += -lcap
endif

ifeq ($(BR2_PACKAGE_LINUX_PAM),y)
VSFTPD_DEPENDENCIES += linux-pam
VSFTPD_LIBS += -lpam
endif

define VSFTPD_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)" \
		LDFLAGS="$(TARGET_LDFLAGS)" LIBS="$(VSFTPD_LIBS)" -C $(@D)
endef

define VSFTPD_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/vsftpd/S70vsftpd $(TARGET_DIR)/etc/init.d/S70vsftpd
endef

define VSFTPD_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(@D)/vsftpd $(TARGET_DIR)/usr/sbin/vsftpd
	test -f $(TARGET_DIR)/etc/vsftpd.conf || \
		$(INSTALL) -D -m 644 $(@D)/vsftpd.conf \
			$(TARGET_DIR)/etc/vsftpd.conf
	$(INSTALL) -d -m 700 $(TARGET_DIR)/usr/share/empty
endef

$(eval $(generic-package))
