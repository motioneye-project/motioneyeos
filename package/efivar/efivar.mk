################################################################################
#
# efivar
#
################################################################################

EFIVAR_VERSION = 34
EFIVAR_SITE = $(call github,rhboot,efivar,$(EFIVAR_VERSION))
EFIVAR_LICENSE = LGPL-2.1
EFIVAR_LICENSE_FILES = COPYING
EFIVAR_INSTALL_STAGING = YES

# -fPIC is needed at least on MIPS, otherwise fails to build shared
# -library.
EFIVAR_MAKE_OPTS = \
	libdir=/usr/lib \
	LDFLAGS="$(TARGET_LDFLAGS) -fPIC"

define EFIVAR_BUILD_CMDS
	# makeguids is an internal host tool and must be built separately with
	# $(HOST_CC), otherwise it gets cross-built.
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) \
		CFLAGS="$(HOST_CFLAGS) -std=gnu99" \
		$(MAKE) -C $(@D)/src gcc_cflags=  makeguids

	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE1) -C $(@D) \
		AR=$(TARGET_AR) NM=$(TARGET_NM) RANLIB=$(TARGET_RANLIB) \
		$(EFIVAR_MAKE_OPTS) \
		all
endef

define EFIVAR_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE1) -C $(@D) \
		$(EFIVAR_MAKE_OPTS) \
		DESTDIR="$(STAGING_DIR)" \
		install
endef

define EFIVAR_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) $(MAKE1) -C $(@D) \
		$(EFIVAR_MAKE_OPTS) \
		DESTDIR="$(TARGET_DIR)" \
		install
endef

$(eval $(generic-package))
