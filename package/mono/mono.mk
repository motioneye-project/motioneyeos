################################################################################
#
# mono
#
################################################################################

MONO_VERSION = 5.2.0.224
MONO_SITE = http://download.mono-project.com/sources/mono
MONO_SOURCE = mono-$(MONO_VERSION).tar.bz2
MONO_LICENSE = GPL-2.0 or MIT (compiler, tools), MIT (libs) or commercial
MONO_LICENSE_FILES = LICENSE mcs/COPYING eglib/COPYING \
	external/Newtonsoft.Json/Tools/7-zip/copying.txt
MONO_INSTALL_STAGING = YES

## Mono native

# patching configure.ac
MONO_AUTORECONF = YES

# Disable managed code (mcs folder) from building
MONO_CONF_OPTS = --with-mcs-docs=no \
	--with-ikvm-native=no \
	--enable-minimal=profiler,debug,aot \
	--disable-mcs-build \
	--enable-static \
	--disable-btls

# The libraries have been built by the host-mono build. Since they are
# architecture-independent, we simply copy them to the target.
define MONO_INSTALL_LIBS
	rsync -av --exclude=*.so --exclude=*.mdb \
		$(HOST_DIR)/lib/mono $(TARGET_DIR)/usr/lib/
endef

MONO_POST_INSTALL_TARGET_HOOKS += MONO_INSTALL_LIBS

ifeq ($(BR2_PACKAGE_LIBICONV),y)
MONO_DEPENDENCIES += libiconv
endif

MONO_DEPENDENCIES += host-mono

## Mono managed

HOST_MONO_CONF_OPTS = --with-mcs-docs=no \
	--disable-libraries \
	--with-ikvm-native=no \
	--enable-minimal=profiler,debug,aot \
	--enable-static \
	--disable-btls

# ensure monolite is used
HOST_MONO_MAKE_OPTS += EXTERNAL_MCS=false

HOST_MONO_DEPENDENCIES = host-monolite host-gettext

define HOST_MONO_SETUP_MONOLITE
	rm -rf $(@D)/mcs/class/lib/monolite
	(cd $(@D)/mcs/class/lib; ln -s $(HOST_DIR)/lib/monolite monolite)
endef

HOST_MONO_POST_CONFIGURE_HOOKS += HOST_MONO_SETUP_MONOLITE

$(eval $(autotools-package))
$(eval $(host-autotools-package))
