################################################################################
#
# speex
#
################################################################################

SPEEX_VERSION = 1.2.0
SPEEX_SITE = https://downloads.xiph.org/releases/speex
SPEEX_LICENSE = BSD-3-Clause
SPEEX_LICENSE_FILES = COPYING
SPEEX_INSTALL_STAGING = YES
SPEEX_DEPENDENCIES = host-pkgconf libogg
SPEEX_CONF_OPTS = \
	--enable-fixed-point

ifeq ($(BR2_PACKAGE_SPEEXDSP),y)
SPEEX_DEPENDENCIES += speexdsp
endif

ifeq ($(BR2_PACKAGE_SPEEX_ARM4),y)
SPEEX_CONF_OPTS += --enable-arm4-asm
endif

ifeq ($(BR2_PACKAGE_SPEEX_ARM5E),y)
SPEEX_CONF_OPTS += --enable-arm5e-asm
endif

define SPEEX_LIBTOOL_FIXUP
	$(SED) 's|^hardcode_libdir_flag_spec=.*|hardcode_libdir_flag_spec=""|g' $(@D)/libtool
	$(SED) 's|^runpath_var=LD_RUN_PATH|runpath_var=DIE_RPATH_DIE|g' $(@D)/libtool
endef

SPEEX_POST_CONFIGURE_HOOKS += SPEEX_LIBTOOL_FIXUP

$(eval $(autotools-package))
