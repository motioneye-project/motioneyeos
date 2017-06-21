################################################################################
#
# kmsxx
#
################################################################################

KMSXX_VERSION = cb0786049f960f2bd383617151b01318e02e9ff9
KMSXX_SITE = $(call github,tomba,kmsxx,$(KMSXX_VERSION))
KMSXX_LICENSE = MPL-2.0
KMSXX_LICENSE_FILES = LICENSE
KMSXX_INSTALL_STAGING = YES
KMSXX_DEPENDENCIES = libdrm host-pkgconf
KMSXX_CONF_OPTS = -DKMSXX_ENABLE_PYTHON=OFF

# Internal error, aborting at dw2gencfi.c:214 in emit_expr_encoded
# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=79509
ifeq ($(BR2_m68k_cf),y)
KMSXX_CONF_OPTS += -DCMAKE_CXX_FLAGS="$(TARGET_CXXFLAGS) -fno-dwarf2-cfi-asm"
endif

ifeq ($(BR2_PACKAGE_KMSXX_INSTALL_TESTS),y)
KMSXX_TESTS = \
	fbtest kmsblank kmscapture \
	kmsprint kmstest kmsview wbcap \
	wbm2m

define KMSXX_INSTALL_TARGET_TESTS
	$(foreach t,$(KMSXX_TESTS),\
		$(INSTALL) -D -m 0755 $(@D)/bin/$(t) \
			$(TARGET_DIR)/usr/bin/$(t)
	)
endef
endif

KMSXX_LIBS = kms++ kms++util

define KMSXX_INSTALL_TARGET_CMDS
	$(if $(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),
		$(foreach l,$(KMSXX_LIBS),\
			$(INSTALL) -D -m 0755 $(@D)/lib/lib$(l).so \
				$(TARGET_DIR)/usr/lib/lib$(l).so
		)
	)
	$(KMSXX_INSTALL_TARGET_TESTS)
endef

define KMSXX_INSTALL_STAGING_CMDS
	$(foreach l,$(KMSXX_LIBS),\
		$(if $(BR2_SHARED_LIBS)$(BR2_SHARED_STATIC_LIBS),
			$(INSTALL) -D -m 0755 $(@D)/lib/lib$(l).so \
				$(STAGING_DIR)/usr/lib/lib$(l).so)
		$(if $(BR2_STATIC_LIBS)$(BR2_SHARED_STATIC_LIBS),
			$(INSTALL) -D -m 0755 $(@D)/lib/lib$(l).a \
				$(STAGING_DIR)/usr/lib/lib$(l).a)
		mkdir -p $(STAGING_DIR)/usr/include/$(l)
		cp -dpfr $(@D)/$(l)/inc/$(l)/* $(STAGING_DIR)/usr/include/$(l)/
	)
endef

$(eval $(cmake-package))
