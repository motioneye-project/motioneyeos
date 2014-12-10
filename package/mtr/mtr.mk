################################################################################
#
# mtr
#
################################################################################

MTR_VERSION = v0.86
MTR_SITE = $(call github,traviscross,mtr,$(MTR_VERSION))
MTR_AUTORECONF = YES
MTR_CONF_OPTS = --without-gtk
MTR_DEPENDENCIES = host-pkgconf $(if $(BR2_PACKAGE_NCURSES),ncurses)
MTR_LICENSE = GPLv2
MTR_LICENSE_FILES = COPYING

# uClibc has res_ninit but not res_nmkquery
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
define MTR_DISABLE_RES_NINIT
	$(SED) 's/#ifdef res_ninit/#if 0/' \
		$(@D)/dns.c
endef
endif

MTR_POST_PATCH_HOOKS += MTR_DISABLE_RES_NINIT

$(eval $(autotools-package))
