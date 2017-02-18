################################################################################
#
# fetchmail
#
################################################################################

FETCHMAIL_VERSION_MAJOR = 6.3
FETCHMAIL_VERSION = $(FETCHMAIL_VERSION_MAJOR).26
FETCHMAIL_SOURCE = fetchmail-$(FETCHMAIL_VERSION).tar.xz
FETCHMAIL_SITE = http://downloads.sourceforge.net/project/fetchmail/branch_$(FETCHMAIL_VERSION_MAJOR)
FETCHMAIL_LICENSE = GPLv2; some exceptions are mentioned in COPYING
FETCHMAIL_LICENSE_FILES = COPYING
FETCHMAIL_AUTORECONF = YES
FETCHMAIL_GETTEXTIZE = YES

FETCHMAIL_CONF_ENV += LIBS="-lz"

FETCHMAIL_CONF_OPTS = \
	--with-ssl=$(STAGING_DIR)/usr

FETCHMAIL_DEPENDENCIES = \
	ca-certificates \
	openssl \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)

$(eval $(autotools-package))
