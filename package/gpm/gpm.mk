################################################################################
#
# gpm
#
################################################################################

GPM_VERSION = 1.20.7
GPM_SOURCE = gpm-$(GPM_VERSION).tar.lzma
GPM_SITE = http://www.nico.schottelius.org/software/gpm/archives
GPM_LICENSE = GPLv2+
GPM_LICENSE_FILES = COPYING
GPM_INSTALL_STAGING = YES
GPM_DEPENDENCIES = host-bison

# if not already installed in staging dir, gpm Makefile may fail to find some
# of the headers needed to generate build dependencies, the first time it is
# built. CPPFLAGS is used to pass the right include path to dependency rules.
GPM_CONF_ENV = \
	CPPFLAGS="$(TARGET_CPPFLAGS) -I$(@D)/src/headers/" \
	ac_cv_path_emacs=no

# For some reason, Microblaze gcc does not define __ELF__, which gpm
# configure script uses to determine whether the architecture uses ELF
# binaries and therefore can build shared libraries. We fix this by
# telling GPM that ELF is used on Microblaze.
ifeq ($(BR2_microblaze),y)
GPM_CONF_ENV += itz_cv_sys_elf=yes
endif

# gpm and ncurses have a circular dependency. As gpm function GPM_Wgetch()
# (requiring ncurses) is not recommended for use by ncurses people themselves
# and as it's better to have gpm support in ncurses that the contrary, we force
# gpm to not look after ncurses explicitly.
# http://invisible-island.net/ncurses/ncurses.faq.html#using_gpm_lib
GPM_CONF_OPTS = --without-curses

# configure is missing but gpm seems not compatible with our autoreconf
# mechanism so we have to do it manually instead of using GPM_AUTORECONF = YES
define GPM_RUN_AUTOGEN
	cd $(@D) && PATH=$(BR_PATH) ./autogen.sh
endef
GPM_PRE_CONFIGURE_HOOKS += GPM_RUN_AUTOGEN

GPM_DEPENDENCIES += host-automake host-autoconf host-libtool

# gpm tries to build/install .info doc even if makeinfo isn't installed on the
# host, so we have to disable global doc installation to prevent autobuild
# errors.
define GPM_DISABLE_DOC_INSTALL
	$(SED) 's/SUBDIRS = src doc contrib/SUBDIRS = src contrib/' \
		$(@D)/Makefile.in
endef
GPM_POST_PATCH_HOOKS += GPM_DISABLE_DOC_INSTALL

ifeq ($(BR2_PACKAGE_GPM_INSTALL_TEST_TOOLS),)
define GPM_REMOVE_TEST_TOOLS_FROM_TARGET
	for tools in mev hltest mouse-test display-buttons \
		get-versions display-coords; do \
			rm -f $(TARGET_DIR)/usr/bin/$$tools ; \
	done
endef
GPM_POST_INSTALL_TARGET_HOOKS += GPM_REMOVE_TEST_TOOLS_FROM_TARGET
endif

define GPM_INSTALL_GPM_ROOT_CONF_ON_TARGET
	$(INSTALL) -m 0644 -D $(@D)/conf/gpm-root.conf $(TARGET_DIR)/etc/
endef

GPM_POST_INSTALL_TARGET_HOOKS += GPM_INSTALL_GPM_ROOT_CONF_ON_TARGET

$(eval $(autotools-package))
