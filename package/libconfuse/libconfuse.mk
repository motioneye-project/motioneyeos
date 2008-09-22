#############################################################
#
# libconfuse
#
#############################################################
LIBCONFUSE_VERSION:=2.6
LIBCONFUSE_SOURCE:=confuse-$(LIBCONFUSE_VERSION).tar.gz
LIBCONFUSE_SITE:=http://bzero.se/confuse/
LIBCONFUSE_AUTORECONF:=NO
LIBCONFUSE_INSTALL_STAGING:=YES
LIBCONFUSE_INSTALL_TARGET:=YES
LIBCONFUSE_INSTALL_TARGET_OPT:=DESTDIR=$(TARGET_DIR) install-strip

LIBCONFUSE_CONF_OPT:=--enable-shared --disable-rpath $(DISABLE_NLS)

LIBCONFUSE_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,libconfuse))
