################################################################################
#
# gcnano-binaries
#
################################################################################

GCNANO_BINARIES_LIB_VERSION = 6.2.4
GCNANO_BINARIES_DRIVER_VERSION = $(GCNANO_BINARIES_LIB_VERSION).p4
GCNANO_BINARIES_USERLAND_VERSION = $(GCNANO_BINARIES_LIB_VERSION).p4-20190626
GCNANO_BINARIES_VERSION = c01642ed5e18cf09ecd905af193e935cb3be95ed
GCNANO_BINARIES_SITE = $(call github,STMicroelectronics,gcnano-binaries,$(GCNANO_BINARIES_VERSION))

GCNANO_BINARIES_LICENSE = MIT, Vivante End User Software License Terms
GCNANO_BINARIES_LICENSE_FILES = EULA
GCNANO_BINARIES_REDISTRIBUTE = NO

GCNANO_BINARIES_DEPENDENCIES = linux wayland libdrm

GCNANO_BINARIES_INSTALL_STAGING = YES

GCNANO_BINARIES_PROVIDES = libegl libgles

# The Github repository doesn't contain the source code as-is: it
# contains a tarball with the kernel driver source code, and a
# self-extractible binary for the user-space parts. So we extract both
# below, and also extract the EULA text from the self-extractible binary
define GCNANO_BINARIES_EXTRACT_HELPER
	tar --strip-components=1 -xJf $(@D)/gcnano-driver-$(GCNANO_BINARIES_DRIVER_VERSION).tar.xz -C $(@D)
	awk 'BEGIN      { start = 0; } \
		/^EOEULA/  { start = 0; } \
			{ if (start) print; } \
		/<<EOEULA/ { start = 1; }' \
		$(@D)/gcnano-userland-multi-$(GCNANO_BINARIES_USERLAND_VERSION).bin > $(@D)/EULA
	cd $(@D) && sh gcnano-userland-multi-$(GCNANO_BINARIES_USERLAND_VERSION).bin --auto-accept
endef

GCNANO_BINARIES_POST_EXTRACT_HOOKS += GCNANO_BINARIES_EXTRACT_HELPER

GCNANO_BINARIES_MODULE_MAKE_OPTS = \
	KERNEL_DIR=$(LINUX_DIR) \
	SOC_PLATFORM=st-st \
	AQROOT=$(@D) \
	DEBUG=0

GCNANO_BINARIES_LIBRARIES = \
	gbm_viv libEGL libGAL libgbm libGLESv1_CM \
	libGLESv2 libGLSLC libOpenVG libVSC

GCNANO_BINARIES_USERLAND_SUBDIR = gcnano-userland-multi-$(GCNANO_BINARIES_USERLAND_VERSION)

GCNANO_BINARIES_PKG_CONFIGS = egl gbm glesv1_cm glesv2 vg

define GCNANO_BINARIES_INSTALL
	$(foreach lib,$(GCNANO_BINARIES_LIBRARIES), \
		$(INSTALL) -D -m 0755 $(@D)/$(GCNANO_BINARIES_USERLAND_SUBDIR)/usr/lib/$(lib).$(GCNANO_BINARIES_LIB_VERSION).multi.release.so \
			$(1)/usr/lib/$(lib).$(GCNANO_BINARIES_LIB_VERSION).multi.release.so ; \
		cp -a $(@D)/$(GCNANO_BINARIES_USERLAND_SUBDIR)/usr/lib/$(lib).so* $(1)/usr/lib
	)
	mkdir -p $(1)/usr/include
	cp -a $(@D)/$(GCNANO_BINARIES_USERLAND_SUBDIR)/usr/include/* $(1)/usr/include/
	$(foreach pkgconfig,$(GCNANO_BINARIES_PKG_CONFIGS), \
		$(INSTALL) -D -m 0644 $(@D)/$(GCNANO_BINARIES_USERLAND_SUBDIR)/usr/lib/pkgconfig/$(pkgconfig).pc \
			$(1)/usr/lib/pkgconfig/$(pkgconfig).pc
	)
endef

define GCNANO_BINARIES_INSTALL_TARGET_CMDS
	$(call GCNANO_BINARIES_INSTALL,$(TARGET_DIR))
endef

define GCNANO_BINARIES_INSTALL_STAGING_CMDS
	$(call GCNANO_BINARIES_INSTALL,$(STAGING_DIR))
endef

$(eval $(kernel-module))
$(eval $(generic-package))
