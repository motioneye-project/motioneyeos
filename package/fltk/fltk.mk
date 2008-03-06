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
FLTK_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

FLTK_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) --prefix=/usr \
		--sysconfdir=/etc 

FLTK_DEPENDENCIES = uclibc $(XSERVER) 

$(eval $(call AUTOTARGETS,package,fltk))