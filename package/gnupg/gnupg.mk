################################################################################
#
# gnupg
#
################################################################################

GNUPG_VERSION = 1.4.14
GNUPG_SOURCE = gnupg-$(GNUPG_VERSION).tar.bz2
GNUPG_SITE = ftp://ftp.gnupg.org/gcrypt/gnupg
GNUPG_LICENSE = GPLv3+
GNUPG_LICENSE_FILES = COPYING
GNUPG_DEPENDENCIES = zlib ncurses
GNUPG_CONF_ENV = ac_cv_sys_symbol_underscore=no
GNUPG_CONF_OPT = --disable-rpath --enable-minimal --disable-regex

ifeq ($(BR2_PACKAGE_BZIP2),y)
GNUPG_CONF_OPT += --enable-bzip2
GNUPG_DEPENDENCIES += bzip2
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
GNUPG_CONF_ENV += ac_cv_path__libcurl_config=$(STAGING_DIR)/usr/bin/curl-config
GNUPG_DEPENDENCIES += libcurl
else
GNUPG_CONF_OPT += --without-libcurl
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
GNUPG_DEPENDENCIES += readline
else
GNUPG_CONF_OPT += --without-readline
endif

ifeq ($(BR2_PACKAGE_GNUPG_RSA),y)
GNUPG_CONF_OPT += --enable-rsa
else
GNUPG_CONF_OPT += --disable-rsa
endif

ifneq ($(BR2_PACKAGE_GNUPG_GPGV),y)
define GNUPG_REMOVE_GPGV
	rm -f $(TARGET_DIR)/usr/bin/gpgv \
		$(TARGET_DIR)/usr/share/man/man1/gpgv.1
endef
GNUPG_POST_INSTALL_TARGET_HOOKS += GNUPG_REMOVE_GPGV
endif

ifneq ($(BR2_PACKAGE_GNUPG_GPGSPLIT),y)
define GNUPG_REMOVE_GPGSPLIT
	rm -f $(TARGET_DIR)/usr/bin/gpgsplit
endef
GNUPG_POST_INSTALL_TARGET_HOOKS += GNUPG_REMOVE_GPGSPLIT
endif

$(eval $(autotools-package))
