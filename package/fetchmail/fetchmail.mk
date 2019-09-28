################################################################################
#
# fetchmail
#
################################################################################

FETCHMAIL_VERSION_MAJOR = 6.4
FETCHMAIL_VERSION = $(FETCHMAIL_VERSION_MAJOR).1
FETCHMAIL_SOURCE = fetchmail-$(FETCHMAIL_VERSION).tar.xz
FETCHMAIL_SITE = http://downloads.sourceforge.net/project/fetchmail/branch_$(FETCHMAIL_VERSION_MAJOR)
FETCHMAIL_LICENSE = GPL-2.0; some exceptions are mentioned in COPYING
FETCHMAIL_LICENSE_FILES = COPYING

FETCHMAIL_CONF_OPTS = \
	--with-ssl=$(STAGING_DIR)/usr

FETCHMAIL_DEPENDENCIES = \
	ca-certificates \
	host-pkgconf \
	openssl \
	$(TARGET_NLS_DEPENDENCIES)

$(eval $(autotools-package))
