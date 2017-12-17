################################################################################
#
# lugaru
#
################################################################################

LUGARU_VERSION = 1.2
LUGARU_SITE = https://bitbucket.org/osslugaru/lugaru/downloads
LUGARU_SOURCE = lugaru-$(LUGARU_VERSION).tar.xz

LUGARU_LICENSE = GPL-2.0+, CC-BY-SA-3.0 (Wolfire and Slib assets), \
	CC-BY-SA-4.0 (OSS Lugaru, Jendraz and Philtron R. assets)
LUGARU_LICENSE_FILES = COPYING.txt CONTENT-LICENSE.txt

LUGARU_DEPENDENCIES = host-pkgconf jpeg libgl libglu libpng libvorbis \
	openal sdl2 zlib

# Avoid incompatible posix_memalign declaration on x86 and x86_64 with
# musl.
# https://gcc.gnu.org/ml/gcc-patches/2015-05/msg01425.html
ifeq ($(BR2_TOOLCHAIN_USES_MUSL):$(BR2_i386)$(BR2_x86_64),y:y)
define LUGARU_REMOVE_PEDANTIC
	$(SED) 's% -pedantic%%' $(@D)/CMakeLists.txt
endef
LUGARU_POST_PATCH_HOOKS += LUGARU_REMOVE_PEDANTIC
endif

LUGARU_CONF_OPTS = -DSYSTEM_INSTALL=ON

$(eval $(cmake-package))
