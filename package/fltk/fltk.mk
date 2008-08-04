#############################################################
#
# fltk
#
#############################################################

FLTK_VERSION = 1.1.7
FLTK_SOURCE = fltk-$(FLTK_VERSION)-source.tar.bz2
FLTK_SITE = http://ftp.easysw.com/pub/fltk/1.1.7/
FLTK_AUTORECONF = NO
FLTK_INSTALL_STAGING = YES
FLTK_INSTALL_TARGET = YES

FLTK_INSTALL_STAGING_OPT = DESTDIR=$(STAGING_DIR) STRIP=$(TARGET_STRIP) install
FLTK_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) STRIP=$(TARGET_STRIP) install

FLTK_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) --prefix=/usr \
		--sysconfdir=/etc --enable-shared --enable-threads --with-x

FLTK_DEPENDENCIES = uclibc $(XSERVER)

$(eval $(call AUTOTARGETS,package,fltk))