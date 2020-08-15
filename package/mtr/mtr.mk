################################################################################
#
# mtr
#
################################################################################

MTR_VERSION = 0.93
MTR_SITE = $(call github,traviscross,mtr,v$(MTR_VERSION))
MTR_AUTORECONF = YES
MTR_CONF_OPTS = --without-gtk
MTR_DEPENDENCIES = host-pkgconf $(if $(BR2_PACKAGE_NCURSES),ncurses)
MTR_LICENSE = GPL-2.0
MTR_LICENSE_FILES = COPYING

$(eval $(autotools-package))
