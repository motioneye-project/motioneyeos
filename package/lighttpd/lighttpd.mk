#############################################################
#
# lighttpd
#
#############################################################

LIGHTTPD_VERSION = 1.4.23
LIGHTTPD_SOURCE = lighttpd-$(LIGHTTPD_VERSION).tar.bz2
LIGHTTPD_SITE = http://www.lighttpd.net/download
LIGHTTPD_LIBTOOL_PATCH = NO
LIGHTTPD_DEPENDENCIES = uclibc

ifneq ($(BR2_LARGEFILE),y)
LIGHTTPD_LFS:=$(DISABLE_LARGEFILE) --disable-lfs
endif

LIGHTTPD_CONF_OPT = \
	--libdir=/usr/lib/lighttpd \
	--libexecdir=/usr/lib \
	--localstatedir=/var \
	--program-prefix="" \
	$(DISABLE_IPV6) \
	$(LIGHTTPD_LFS)

ifeq ($(BR2_PACKAGE_LIGHTTPD_OPENSSL),y)
LIGHTTPD_DEPENDENCIES += openssl
LIGHTTPD_CONF_OPT += --with-openssl
else
LIGHTTPD_CONF_OPT += --without-openssl
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_ZLIB),y)
LIGHTTPD_DEPENDENCIES += zlib
LIGHTTPD_CONF_OPT += --with-zlib
else
LIGHTTPD_CONF_OPT += --without-zlib
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_BZIP2),y)
LIGHTTPD_DEPENDENCIES += bzip2
LIGHTTPD_CONF_OPT += --with-bzip2
else
LIGHTTPD_CONF_OPT += --without-bzip2
endif

ifeq ($(BR2_PACKAGE_LIGHTTPD_PCRE),y)
LIGHTTPD_CONF_ENV = PCRE_LIB="-lpcre"
LIGHTTPD_DEPENDENCIES += pcre
LIGHTTPD_CONF_OPT += --with-pcre
else
LIGHTTPD_CONF_OPT += --without-pcre
endif

$(eval $(call AUTOTARGETS,package,lighttpd))

$(LIGHTTPD_TARGET_UNINSTALL):
	$(call MESSAGE,"Uninstalling")
	rm -f $(TARGET_DIR)/usr/sbin/lighttpd
	rm -f $(TARGET_DIR)/usr/sbin/lighttpd-angel
	rm -rf $(TARGET_DIR)/usr/lib/lighttpd
	rm -f $(LIGHTTPD_TARGET_INSTALL_TARGET) $(LIGHTTPD_HOOK_POST_INSTALL)
