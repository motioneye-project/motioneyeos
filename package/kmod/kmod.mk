KMOD_VERSION = 3
KMOD_SOURCE = kmod-$(KMOD_VERSION).tar.bz2
KMOD_SITE = http://git.profusion.mobi/cgit.cgi/kmod.git/snapshot
KMOD_INSTALL_STAGING =YES
KMOD_AUTORECONF = YES
KMOD_DEPENDENCIES = host-pkg-config

$(eval $(call AUTOTARGETS))
