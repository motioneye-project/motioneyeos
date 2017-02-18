################################################################################
#
# jasper
#
################################################################################

JASPER_VERSION = 1.900.1
JASPER_SITE = http://sources.openelec.tv/devel
JASPER_SOURCE = jasper-$(JASPER_VERSION).tar.bz2
JASPER_INSTALL_STAGING = YES
JASPER_DEPENDENCIES = jpeg
JASPER_LICENSE = MIT
JASPER_LICENSE_FILES = LICENSE
# needed to fix rpath issue (http://autobuild.buildroot.net/results/307/307cac65287420252a5bb64715d9a1edd90e72fa/)
JASPER_AUTORECONF = YES

# Xtensa gcc is unable to generate correct code with -O0 enabled by
# --enable-debug. Allow package build but disable debug.
ifeq ($(BR2_xtensa)$(BR2_ENABLE_DEBUG),yy)
JASPER_CONF_OPTS += --disable-debug
endif

$(eval $(autotools-package))
