################################################################################
#
# libostree
#
################################################################################

LIBOSTREE_VERSION = 2017.13
LIBOSTREE_SOURCE = libostree-$(LIBOSTREE_VERSION).tar.xz
LIBOSTREE_SITE = https://github.com/ostreedev/ostree/releases/download/v$(LIBOSTREE_VERSION)

LIBOSTREE_LICENSE = GPL-2.0+
LIBOSTREE_LICENSE_FILES = COPYING
LIBOSTREE_DEPENDENCIES = e2fsprogs host-pkgconf libfuse libglib2 libgpgme xz

LIBOSTREE_CONF_OPTS += \
	--with-gpgme-prefix=$(STAGING_DIR)/usr \
	--disable-gtk-doc \
	--disable-gtk-doc-html \
	--disable-gtk-doc-pdf \
	--disable-man

ifeq ($(BR2_PACKAGE_OPENSSL),y)
LIBOSTREE_CONF_OPTS += --with-openssl
LIBOSTREE_DEPENDENCIES += openssl
else
LIBOSTREE_CONF_OPTS += --without-openssl
endif

ifeq ($(BR2_PACKAGE_AVAHI),y)
LIBOSTREE_CONF_OPTS += --with-avahi
LIBOSTREE_DEPENDENCIES += avahi
else
LIBOSTREE_CONF_OPTS += --without-avahi
endif

#cURL support depends on libsoup
ifeq ($(BR2_PACKAGE_LIBSOUP),y)
LIBOSTREE_CONF_OPTS += --with-libsoup
LIBOSTREE_DEPENDENCIES += libsoup
ifeq ($(BR2_PACKAGE_LIBCURL),y)
LIBOSTREE_CONF_OPTS += --with-curl
LIBOSTREE_DEPENDENCIES += libcurl
else
LIBOSTREE_CONF_OPTS += --without-curl
endif
else
LIBOSTREE_CONF_OPTS += --without-libsoup --without-curl
endif

ifeq ($(BR2_PACKAGE_LIBARCHIVE),y)
LIBOSTREE_CONF_OPTS += --with-libarchive
LIBOSTREE_DEPENDENCIES += libarchive
else
LIBOSTREE_CONF_OPTS += --without-libarchive
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
LIBOSTREE_CONF_OPTS += --with-selinux
LIBOSTREE_DEPENDENCIES += libselinux
else
LIBOSTREE_CONF_OPTS += --without-selinux
endif

$(eval $(autotools-package))
