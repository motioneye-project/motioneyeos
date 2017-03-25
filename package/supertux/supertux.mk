################################################################################
#
# supertux
#
################################################################################

SUPERTUX_VERSION = 0.5.1
SUPERTUX_SITE = https://github.com/SuperTux/supertux/releases/download/v$(SUPERTUX_VERSION)
SUPERTUX_SOURCE = SuperTux-v$(SUPERTUX_VERSION)-Source.tar.gz

# Supertux itself is GPLv3+, but it bundles a few libraries with different
# licenses (sexp-cpp, squirrel, tinygettext) which are linked statically.
SUPERTUX_LICENSE = GPL-3.0+ (code), CC-BY-SA-2.0, CC-BY-SA-3.0, GPL-2.0+ (images music sounds)
SUPERTUX_LICENSE_FILES = LICENSE.txt data/AUTHORS

# Use bundled squirrel, tinygettext sexp-cpp packages which are hardcoded in
# the CMake build system.
SUPERTUX_DEPENDENCIES = host-pkgconf boost libcurl libgl libglew libglu \
	libogg libvorbis openal physfs sdl2 sdl2_image

# ENABLE_BOOST_STATIC_LIBS=OFF: use boost shared libraries since supertux
# depends on !BR2_STATIC_LIBS and boost provide only shared libraries with
# BR2_SHARED_LIBS.
# ENABLE_OPENGL=ON: Can be disabled but will make SuperTux unplayable slow.
# GLBINDING_ENABLED=OFF: use GLEW (default) instead of glbinding.
# Install the game directly in /usr/bin and game data in /usr/share/supertux2.
# Force using physfs.so from staging since the check on PHYSFS_getPrefDir symbol
# in physfs.h (CHECK_SYMBOL_EXISTS) doesn't work.
SUPERTUX_CONF_OPTS += \
	-DENABLE_BOOST_STATIC_LIBS=OFF \
	-DBUILD_DOCUMENTATION=OFF \
	-DENABLE_OPENGL=ON \
	-DGLBINDING_ENABLED=OFF \
	-DINSTALL_SUBDIR_BIN="bin" \
	-DINSTALL_SUBDIR_SHARE="share/supertux2" \
	-DUSE_SYSTEM_PHYSFS=ON

# Avoid incompatible posix_memalign declaration on x86 and x86_64 with
# musl.
# https://gcc.gnu.org/ml/gcc-patches/2015-05/msg01425.html
ifeq ($(BR2_TOOLCHAIN_USES_MUSL):$(BR2_i386)$(BR2_x86_64),y:y)
define SUPERTUX_REMOVE_PEDANTIC
	$(SED) 's% -pedantic%%' $(@D)/CMakeLists.txt
	$(SED) 's%CHECK_CXX_FLAG(pedantic)%%' $(@D)/external/tinygettext/CMakeLists.txt
endef
SUPERTUX_POST_PATCH_HOOKS += SUPERTUX_REMOVE_PEDANTIC
endif

$(eval $(cmake-package))
