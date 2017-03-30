################################################################################
#
# lcdapi
#
################################################################################

LCDAPI_VERSION = v0.10
LCDAPI_SITE = $(call github,spdawson,lcdapi,$(LCDAPI_VERSION))
LCDAPI_LICENSE = LGPL-2.1+
LCDAPI_LICENSE_FILES = COPYING
LCDAPI_AUTORECONF = YES
LCDAPI_INSTALL_STAGING = YES

# Internal error, aborting at dw2gencfi.c:214 in emit_expr_encoded
# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79509
ifeq ($(BR2_m68k_cf),y)
LCDAPI_CONF_OPTS += CXXFLAGS="$(TARGET_CXXFLAGS) -fno-dwarf2-cfi-asm"
endif

define LCDAPI_CREATE_M4_DIR
	mkdir -p $(@D)/m4
endef

LCDAPI_POST_PATCH_HOOKS += LCDAPI_CREATE_M4_DIR

$(eval $(autotools-package))
