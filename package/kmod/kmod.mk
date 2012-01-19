KMOD_VERSION = 4
KMOD_SOURCE = kmod-$(KMOD_VERSION).tar.xz
KMOD_SITE = http://packages.profusion.mobi/kmod/
KMOD_INSTALL_STAGING = YES
KMOD_DEPENDENCIES = host-pkg-config

$(eval $(call AUTOTARGETS))
