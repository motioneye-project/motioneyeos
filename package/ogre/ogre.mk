################################################################################
#
# ogre
#
################################################################################

OGRE_VERSION = 1.12.0
OGRE_SITE = $(call github,OGRECave,ogre,v$(OGRE_VERSION))
OGRE_LICENSE = MIT (main library, DeferredShadingMedia samples), Public Domain (samples and plugins), Zlib (tinyxml)
OGRE_LICENSE_FILES = LICENSE
OGRE_INSTALL_STAGING = YES

# Ogre use a bundled version of tinyxml
OGRE_DEPENDENCIES = host-pkgconf \
	freetype \
	libfreeimage \
	libgl \
	sdl2 \
	xlib_libX11 \
	xlib_libXaw \
	xlib_libXext \
	xlib_libXrandr \
	zziplib

OGRE_CFLAGS = $(TARGET_CFLAGS) -DGLEW_NO_GLU
OGRE_CXXFLAGS = $(TARGET_CXXFLAGS) -DGLEW_NO_GLU

# Unbundle freetype and zziplib.
# Disable java and nvidia cg support.
OGRE_CONF_OPTS = -DOGRE_BUILD_DEPENDENCIES=OFF \
	-DOGRE_BUILD_COMPONENT_JAVA=OFF \
	-DOGRE_BUILD_PLUGIN_CG=OFF \
	-DOGRE_INSTALL_DOCS=OFF \
	-DCMAKE_C_FLAGS="$(OGRE_CFLAGS)" \
	-DCMAKE_CXX_FLAGS="$(OGRE_CXXFLAGS)"

# Enable optional python component if python interpreter is present on the target.
ifeq ($(BR2_PACKAGE_PYTHON)$(BR2_PACKAGE_PYTHON3),y)
OGRE_DEPENDENCIES += host-swig \
	$(if $(BR2_PACKAGE_PYTHON3),host-python3,host-python)
OGRE_CONF_OPTS += -DOGRE_BUILD_COMPONENT_PYTHON=ON
else
OGRE_CONF_OPTS += -DOGRE_BUILD_COMPONENT_PYTHON=OFF
endif

# Uses __atomic_fetch_add_8
ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
OGRE_CXXFLAGS += -latomic
endif

$(eval $(cmake-package))
