################################################################################
#
# mono
#
################################################################################

MONO_VERSION = 4.4.2.11
MONO_SITE = http://download.mono-project.com/sources/mono
MONO_SOURCE = mono-$(MONO_VERSION).tar.bz2
MONO_LICENSE = GPLv2 or MIT (compiler, tools), LGPLv2 (runtime libs), MIT (class libs) or commercial
MONO_LICENSE_FILES = LICENSE COPYING.LIB mcs/COPYING.LIB mcs/COPYING \
	eglib/COPYING external/Newtonsoft.Json/Tools/7-zip/copying.txt
MONO_INSTALL_STAGING = YES

## Mono native

# patching configure.ac
MONO_AUTORECONF = YES

# Disable managed code (mcs folder) from building
MONO_CONF_OPTS = --disable-gtk-doc \
	--with-mcs-docs=no \
	--with-moonlight=no \
	--with-ikvm-native=no \
	--enable-minimal=aot,profiler,debug \
	--disable-mcs-build \
	--enable-static

# The libraries have been built by the host-mono build. Since they are
# architecture-independent, we simply copy them to the target.
define MONO_INSTALL_LIBS
	rsync -av --exclude=*.so --exclude=*.mdb \
		$(HOST_DIR)/usr/lib/mono $(TARGET_DIR)/usr/lib/
	rsync -av $(HOST_DIR)/etc/mono $(TARGET_DIR)/etc
endef

MONO_POST_INSTALL_TARGET_HOOKS += MONO_INSTALL_LIBS

ifeq ($(BR2_PACKAGE_LIBICONV),y)
MONO_DEPENDENCIES += libiconv
endif

MONO_DEPENDENCIES += host-mono

## Mono managed

HOST_MONO_CONF_OPTS = --disable-gtk-doc \
	--with-mcs-docs=no \
	--with-moonlight=no \
	--disable-libraries \
	--with-ikvm-native=no \
	--enable-minimal=aot,profiler,debug \
	--enable-static

# ensure monolite is used
HOST_MONO_MAKE_OPTS += EXTERNAL_MCS=false

HOST_MONO_DEPENDENCIES = host-monolite host-gettext

define HOST_MONO_SETUP_MONOLITE
	rm -rf $(@D)/mcs/class/lib/monolite
	(cd $(@D)/mcs/class/lib; ln -s $(HOST_DIR)/usr/lib/monolite monolite)
endef

HOST_MONO_POST_CONFIGURE_HOOKS += HOST_MONO_SETUP_MONOLITE

$(eval $(autotools-package))
$(eval $(host-autotools-package))
