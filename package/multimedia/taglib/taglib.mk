#############################################################
#
# taglib
#
#############################################################
TAGLIB_VERSION = 1.5
TAGLIB_SOURCE = taglib-$(TAGLIB_VERSION).tar.gz
TAGLIB_SITE = http://developer.kde.org/~wheeler/files/src
TAGLIB_LIBTOOL_PATCH = NO
TAGLIB_INSTALL_STAGING = YES

TAGLIB_DEPENDENCIES = uclibc

TAGLIB_CONF_ENV = \
	DO_NOT_COMPILE='bindings tests examples' \
	ac_cv_header_cppunit_extensions_HelperMacros_h=no \
	ac_cv_header_zlib_h=$(if $(BR2_PACKAGE_ZLIB),yes,no)

TAGLIB_CONF_OPT = --disable-libsuffix --program-prefix=''

$(eval $(call AUTOTARGETS,package/multimedia,taglib))

ifneq ($(BR2_HAVE_DEVFILES),y)
$(TAGLIB_HOOK_POST_INSTALL):
	rm -f $(TARGET_DIR)/usr/bin/taglib-config
	touch $@
endif
