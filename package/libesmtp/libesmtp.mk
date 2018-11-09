################################################################################
#
# libesmtp
#
################################################################################

LIBESMTP_VERSION = 1.0.6
LIBESMTP_SOURCE = libesmtp-$(LIBESMTP_VERSION).tar.bz2
LIBESMTP_SITE = http://brianstafford.info/libesmtp
LIBESMTP_INSTALL_STAGING = YES
LIBESMTP_CONFIG_SCRIPTS = libesmtp-config
LIBESMTP_DEPENDENCIES = $(if $(BR2_PACKAGE_OPENSSL),openssl)
LIBESMTP_LICENSE = GPL-2.0+ (examples), LGPL-2.1+ (library)
LIBESMTP_LICENSE_FILES = COPYING COPYING.LIB

$(eval $(autotools-package))
