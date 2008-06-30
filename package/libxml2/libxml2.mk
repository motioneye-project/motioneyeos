#############################################################
#
# libxml2
#
#############################################################

LIBXML2_VERSION = 2.6.29
LIBXML2_SOURCE = libxml2-sources-$(LIBXML2_VERSION).tar.gz
LIBXML2_SITE = ftp://xmlsoft.org/libxml2
LIBXML2_AUTORECONF = NO
LIBXML2_INSTALL_STAGING = YES
LIBXML2_INSTALL_TARGET = YES

ifneq ($(BR2_LARGEFILE),y)
LIBXML2_CONF_ENV = CC="$(TARGET_CC) $(TARGET_CFLAGS) -DNO_LARGEFILE_SOURCE"
endif

LIBXML2_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) --prefix=/usr \
		--exec-prefix=/usr --bindir=/usr/bin \
		--sbindir=/usr/sbin --libexecdir=/usr/lib \
		--sysconfdir=/etc --datadir=/usr/share \
		--localstatedir=/var --mandir=/usr/man \
		--infodir=/usr/info --includedir=/usr/include \
		--with-gnu-ld --enable-shared \
		--enable-static --enable-ipv6=no \
		--without-debugging --without-python \
		--without-threads $(DISABLE_NLS)

LIBXML2_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,libxml2))

$(LIBXML2_HOOK_POST_INSTALL):
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/usr/lib/libxml2*so*
	touch $@
