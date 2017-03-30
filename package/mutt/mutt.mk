################################################################################
#
# mutt
#
################################################################################

MUTT_VERSION = 1.7.1
MUTT_SITE = https://bitbucket.org/mutt/mutt/downloads
MUTT_LICENSE = GPL-2.0+
MUTT_LICENSE_FILES = GPL
MUTT_DEPENDENCIES = ncurses
MUTT_CONF_OPTS = --disable-smtp
MUTT_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIBICONV),y)
MUTT_DEPENDENCIES += libiconv
MUTT_CONF_OPTS += --enable-iconv
endif

ifeq ($(BR2_PACKAGE_LIBIDN),y)
MUTT_DEPENDENCIES += libidn
MUTT_CONF_OPTS += --with-idn
else
MUTT_CONF_OPTS += --without-idn
endif

ifeq ($(BR2_PACKAGE_MUTT_IMAP),y)
MUTT_CONF_OPTS += --enable-imap
else
MUTT_CONF_OPTS += --disable-imap
endif

ifeq ($(BR2_PACKAGE_MUTT_POP3),y)
MUTT_CONF_OPTS += --enable-pop
else
MUTT_CONF_OPTS += --disable-pop
endif

# SSL support is only used by imap or pop3 module
ifneq ($(BR2_PACKAGET_MUTT_IMAP)$(BR2_PACKAGE_MUTT_POP3),)
ifeq ($(BR2_PACKAGE_OPENSSL),y)
MUTT_DEPENDENCIES += openssl
MUTT_CONF_OPTS += --with-ssl=$(STAGING_DIR)/usr
else
MUTT_CONF_OPTS += --without-ssl
endif
else
MUTT_CONF_OPTS += --without-ssl
endif

# Avoid running tests to check for:
#  - target system is *BSD
#  - C99 conformance (snprintf, vsnprintf)
#  - behaviour of the regex library
#  - if mail spool directory is world/group writable
#  - we have a working libiconv
MUTT_CONF_ENV += \
	mutt_cv_bsdish=no \
	mutt_cv_c99_snprintf=yes \
	mutt_cv_c99_vsnprintf=yes \
	mutt_cv_regex_broken=no \
	mutt_cv_worldwrite=yes \
	mutt_cv_groupwrite=yes \
	mutt_cv_iconv_good=yes \
	mutt_cv_iconv_nontrans=no

MUTT_CONF_OPTS += --with-mailpath=/var/mail

define MUTT_VAR_MAIL
	ln -sf /tmp $(TARGET_DIR)/var/mail
endef
MUTT_POST_INSTALL_TARGET_HOOKS += MUTT_VAR_MAIL

$(eval $(autotools-package))
