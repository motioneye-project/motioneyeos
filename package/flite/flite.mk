################################################################################
#
# flite
#
################################################################################

FLITE_VERSION = 1.4
FLITE_SOURCE = flite-$(FLITE_VERSION)-release.tar.bz2
FLITE_SITE = http://www.speech.cs.cmu.edu/flite/packed/flite-$(FLITE_VERSION)
# $ tar tf flite-1.4-release.tar.bz2
# ...
# flite-1.4-release//install-sh
# flite-1.4-release//mkinstalldirs
# flite-1.4-release//Exports.def
# flite-1.4-release//flite.sln
# flite-1.4-release//fliteDll.vcproj
# flite-1.4-release/config/Makefile
# flite-1.4-release/config/common_make_rules
# flite-1.4-release/config/project.mak
# flite-1.4-release/config/config.in
# flite-1.4-release/config/system.mak.in
#
# So, we set FLITE_STRIP_COMPONENTS=0 to avoid writing to "/", and then
# build in flite-1.4-release/
FLITE_STRIP_COMPONENTS = 0
FLITE_SUBDIR = flite-$(FLITE_VERSION)-release
FLITE_LICENSE = BSD-4-Clause
FLITE_LICENSE_FILES = $(FLITE_SUBDIR)/COPYING

FLITE_INSTALL_STAGING = YES
# Patching configure.in
FLITE_AUTORECONF = YES
FLITE_DEPENDENCIES = host-pkgconf

# Sadly, Flite does not support parallel build, especially when building its
# shared libraries.
FLITE_MAKE = $(MAKE1)

ifeq ($(BR2_PACKAGE_ALSA_LIB),y)
FLITE_DEPENDENCIES += alsa-lib
FLITE_CONF_OPTS += --with-audio=alsa
else
FLITE_CONF_OPTS += --with-audio=oss
endif

$(eval $(autotools-package))
