################################################################################
#
# mutt
#
################################################################################

MUTT_VERSION = 1.5.23
MUTT_SITE = http://downloads.sourceforge.net/project/mutt/mutt
MUTT_LICENSE = GPLv2+
MUTT_LICENSE_FILES = GPL
MUTT_DEPENDENCIES = ncurses
MUTT_CONF_OPTS = --disable-smtp
MUTT_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_LIBICONV),y)
MUTT_DEPENDENCIES += libiconv
MUTT_CONF_OPTS += --enable-iconv
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

$(eval $(autotools-package))
