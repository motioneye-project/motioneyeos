#############################################################
#
# lighttpd
#
#############################################################
LIGHTTPD_VERSION:=1.4.19
LIGHTTPD_SOURCE:=lighttpd-$(LIGHTTPD_VERSION).tar.bz2
LIGHTTPD_SITE:=http://www.lighttpd.net/download
LIGHTTPD_INSTALL_STAGING = NO
LIGHTTPD_INSTALL_TARGET = YES
LIGHTTPD_DEPENDENCIES = uclibc
LIGHTTPD_CONF_ENV = 
LIGHTTPD_CONF_OPT = \
	--target=$(GNU_TARGET_NAME) \
	--host=$(GNU_TARGET_NAME) \
	--build=$(GNU_HOST_NAME) \
	--prefix=/usr \
	--libdir=/usr/lib/lighttpd \
	--libexecdir=/usr/lib \
	--sysconfdir=/etc \
	--localstatedir=/var \
	--program-prefix="" \
	$(DISABLE_IPV6) \
	$(DISABLE_LARGEFILE)

ifeq ($(strip $(BR2_PACKAGE_LIGHTTPD_OPENSSL)),y)
LIGHTTPD_DEPENDENCIES += openssl
LIGHTTPD_CONF_OPT += --with-openssl
else
LIGHTTPD_CONF_OPT += --without-openssl
endif

ifeq ($(strip $(BR2_PACKAGE_LIGHTTPD_PCRE)),y)
LIGHTTPD_CONF_ENV += PCRE_LIB="-lpcre"
LIGHTTPD_DEPENDENCIES += pcre
LIGHTTPD_CONF_OPT += --with-pcre
else
LIGHTTPD_CONF_OPT += --without-pcre
endif

$(eval $(call AUTOTARGETS,package,lighttpd))
