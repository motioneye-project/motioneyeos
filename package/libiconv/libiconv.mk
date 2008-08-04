#############################################################
#
# libiconv
#
#############################################################
LIBICONV_VERSION = 1.12
LIBICONV_SOURCE = libiconv-$(LIBICONV_VERSION).tar.gz
LIBICONV_SITE = http://ftp.gnu.org/pub/gnu/libiconv
LIBICONV_AUTORECONF = NO
LIBICONV_INSTALL_STAGING = YES
LIBICONV_INSTALL_TARGET = YES

LIBICONV_INSTALL_TARGET_OPT = DESTDIR=$(TARGET_DIR) install

LIBICONV_DEPENDENCIES = uclibc

$(eval $(call AUTOTARGETS,package,libiconv))

