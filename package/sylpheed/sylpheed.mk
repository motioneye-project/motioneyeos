################################################################################
#
# sylpheed
#
################################################################################

SYLPHEED_VERSION_MAJOR = 3.2
SYLPHEED_VERSION = $(SYLPHEED_VERSION_MAJOR).0
SYLPHEED_SOURCE = sylpheed-$(SYLPHEED_VERSION).tar.bz2
SYLPHEED_SITE = http://sylpheed.sraoss.jp/sylpheed/v$(SYLPHEED_VERSION_MAJOR)
SYLPHEED_LICENSE = GPL-2.0+ (executables), LGPL-2.1+ (library, attachment plugin)
SYLPHEED_LICENSE_FILES = COPYING COPYING.LIB
SYLPHEED_CONF_OPTS = --disable-gtkspell --disable-gpgme
SYLPHEED_DEPENDENCIES = host-pkgconf libgtk2

# Remove the -I$(includedir) from the Makefiles
# because it refers to the host /usr/include.
define SYLPHEED_PRECONFIGURE
	for i in $$(find $(@D) -name "Makefile*"); do \
		sed -i 's:-I$$(includedir)::g' $$i; \
	done
endef

SYLPHEED_PRE_CONFIGURE_HOOKS += SYLPHEED_PRECONFIGURE

ifeq ($(BR2_PACKAGE_OPENSSL),y)
SYLPHEED_DEPENDENCIES += openssl
SYLPHEED_CONF_OPTS += --enable-ssl
else
SYLPHEED_CONF_OPTS += --disable-ssl
endif

$(eval $(autotools-package))
