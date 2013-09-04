################################################################################
#
# linux-pam
# 
################################################################################

LINUX_PAM_VERSION = 1.1.6
LINUX_PAM_SOURCE = Linux-PAM-$(LINUX_PAM_VERSION).tar.bz2
LINUX_PAM_SITE = http://linux-pam.org/library/
LINUX_PAM_INSTALL_STAGING = YES
LINUX_PAM_CONF_OPT = \
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
	LINUX_PAM_MAKE_OPT += LIBS=-lintl
endif

$(eval $(autotools-package))
