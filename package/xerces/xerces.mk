################################################################################
#
# xerces
#
################################################################################

XERCES_VERSION = 3.1.3
XERCES_SOURCE = xerces-c-$(XERCES_VERSION).tar.xz
XERCES_SITE = http://archive.apache.org/dist/xerces/c/3/sources
XERCES_LICENSE = Apache-2.0
XERCES_LICENSE_FILES = LICENSE
XERCES_MAKE = $(MAKE1)
XERCES_INSTALL_STAGING = YES
XERCES_CONF_OPTS = \
	--disable-threads \
	--with-gnu-ld

define XERCES_DISABLE_SAMPLES
	$(SED) 's/ samples//' $(@D)/Makefile.in
endef

XERCES_POST_PATCH_HOOKS += XERCES_DISABLE_SAMPLES

ifeq ($(BR2_PACKAGE_ICU),y)
XERCES_CONF_OPTS += --with-icu=$(STAGING_DIR)/usr
XERCES_DEPENDENCIES += icu
else
XERCES_CONF_OPTS += --without-icu
endif

ifeq ($(BR2_PACKAGE_LIBICONV),y)
XERCES_CONF_ENV += LIBS=-liconv
XERCES_DEPENDENCIES += libiconv
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
XERCES_CONF_OPTS += --enable-netaccessor-curl --with-curl=$(STAGING_DIR)/usr/lib
XERCES_DEPENDENCIES += libcurl
else
XERCES_CONF_OPTS += --disable-network
endif

$(eval $(autotools-package))
