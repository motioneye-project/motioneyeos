################################################################################
#
# mtr
#
################################################################################

MTR_VERSION = 66de3ecbab28b054b868a73fbb57f30549d770ac
MTR_SITE = $(call github,traviscross,mtr,$(MTR_VERSION))
MTR_AUTORECONF = YES
MTR_CONF_OPTS = --without-gtk
MTR_DEPENDENCIES = host-pkgconf $(if $(BR2_PACKAGE_NCURSES),ncurses)
MTR_LICENSE = GPLv2
MTR_LICENSE_FILES = COPYING

$(eval $(autotools-package))
