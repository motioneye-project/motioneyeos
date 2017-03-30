################################################################################
#
# lensfun
#
################################################################################

LENSFUN_VERSION = 0.3.2
LENSFUN_SITE = https://sourceforge.net/projects/lensfun/files/$(LENSFUN_VERSION)
LENSFUN_LICENSE = LGPL-3.0+ (libraries), GPL-3.0+ (programs)
LENSFUN_LICENSE_FILES = docs/gpl-3.0.txt docs/lgpl-3.0.txt
LENSFUN_INSTALL_STAGING = YES
LENSFUN_DEPENDENCIES = libglib2

# lensfun doesn't support in source build, it fail to build lensfun tools.
LENSFUN_SUPPORTS_IN_SOURCE_BUILD = NO

ifeq ($(BR2_X86_CPU_HAS_SSE),y)
LENSFUN_CONF_OPTS += -DBUILD_FOR_SSE=ON
else
LENSFUN_CONF_OPTS += -DBUILD_FOR_SSE=OFF
endif

ifeq ($(BR2_X86_CPU_HAS_SSE2),y)
LENSFUN_CONF_OPTS += -DBUILD_FOR_SSE2=ON
else
LENSFUN_CONF_OPTS += -DBUILD_FOR_SSE2=OFF
endif

ifeq ($(BR2_PACKAGE_LENSFUN_TOOLS),y)
LENSFUN_DEPENDENCIES += libpng
LENSFUN_CONF_OPTS += -DBUILD_LENSTOOL=ON
# broken
else
LENSFUN_CONF_OPTS += -DBUILD_LENSTOOL=OFF
endif

ifeq ($(BR2_STATIC_LIBS),y)
LENSFUN_CONF_OPTS += -DBUILD_STATIC=ON
else
LENSFUN_CONF_OPTS += -DBUILD_STATIC=OFF
endif

# Don't install helper scripts (which require python3 and gksudo).
# Don't run setup.py on the host.
LENSFUN_CONF_OPTS += -DINSTALL_HELPER_SCRIPTS=OFF -DPYTHON=OFF

$(eval $(cmake-package))
