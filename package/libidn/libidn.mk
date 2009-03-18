#############################################################
#
# libidn
#
#############################################################
LIBIDN_VERSION = 1.9
LIBIDN_SOURCE = libidn-$(LIBIDN_VERSION).tar.gz
LIBIDN_SITE = http://ftp.gnu.org/gnu/libidn/
LIBIDN_INSTALL_STAGING = YES
LIBIDN_INSTALL_TARGET = YES
LIBIDN_CONF_OPT = --enable-shared
LIBIDN_DEPENDENCIES = uclibc host-pkgconfig gettext $(if $(BR2_PACKAGE_LIBICONV),libiconv)

$(eval $(call AUTOTARGETS,package,libidn))
