################################################################################
#
# libseccomp
#
################################################################################

LIBSECCOMP_VERSION         = 1.0.0
LIBSECCOMP_SOURCE          = libseccomp-$(LIBSECCOMP_VERSION).tar.gz
LIBSECCOMP_SITE            = http://downloads.sourceforge.net/project/libseccomp
LIBSECCOMP_LICENSE         = LGPLv2.1
LIBSECCOMP_LICENSE_FILES   = LICENSE
LIBSECCOMP_INSTALL_STAGING = YES

# Needed for configure to find our system headers:
LIBSECCOMP_CONF_ENV            = SYSROOT=$(STAGING_DIR)
LIBSECCOMP_MAKE_ENV            = $(TARGET_CONFIGURE_OPTS)
LIBSECCOMP_MAKE_OPT            = SUBDIRS_BUILD=src
LIBSECCOMP_INSTALL_STAGING_OPT = SUBDIRS_BUILD=src SUBDIRS_INSTALL="src include" DESTDIR=$(STAGING_DIR) install
LIBSECCOMP_INSTALL_TARGET_OPT  = SUBDIRS_BUILD=src SUBDIRS_INSTALL="src include" DESTDIR=$(TARGET_DIR) install

# Not a real autotools package, but works quite OK nonetheless
$(eval $(autotools-package))
