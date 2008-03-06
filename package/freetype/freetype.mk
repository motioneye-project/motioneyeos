#############################################################
#
# freetype
#
#############################################################
FREETYPE_VERSION = $(strip $(subst ",, $(BR2_FREETYPE_VERSION)))
FREETYPE_SOURCE = freetype-$(FREETYPE_VERSION).tar.bz2
FREETYPE_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/freetype
FREETYPE_AUTORECONF = NO
FREETYPE_INSTALL_STAGING = YES
FREETYPE_INSTALL_TARGET = YES
FREETYPE_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

FREETYPE_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) --prefix=/usr \
		--exec-prefix=/usr --bindir=/usr/bin \
		--sbindir=/usr/sbin --libdir=/usr/lib \
		--libexecdir=/usr/lib --sysconfdir=/etc \
		--datadir=/usr/share --localstatedir=/var \
		--includedir=/usr/include --mandir=/usr/man \
		--infodir=/usr/info 

FREETYPE_MAKE_OPT = CCexe="$(HOSTCC)"
FREETYPE_DEPENDENCIES = uclibc pkgconfig

$(eval $(call AUTOTARGETS,package,freetype))