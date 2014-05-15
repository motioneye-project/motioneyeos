################################################################################
#
# gpu-viv-bin-mx6q
#
################################################################################

ifeq ($(BR2_ARM_EABIHF),y)
GPU_VIV_BIN_MX6Q_VERSION = $(FREESCALE_IMX_VERSION)-hfp
else
GPU_VIV_BIN_MX6Q_VERSION = $(FREESCALE_IMX_VERSION)-sfp
endif
GPU_VIV_BIN_MX6Q_SITE    = $(FREESCALE_IMX_SITE)
GPU_VIV_BIN_MX6Q_SOURCE  = gpu-viv-bin-mx6q-$(GPU_VIV_BIN_MX6Q_VERSION).bin

GPU_VIV_BIN_MX6Q_INSTALL_STAGING = YES

GPU_VIV_BIN_MX6Q_LICENSE = Freescale Semiconductor Software License Agreement

# No license file is included in the archive; we could extract it from
# the self-extractor, but that's just too much effort.
# This is a legal minefield: the EULA specifies that
# the Board Support Package includes software and hardware (sic!)
# for which a separate license is needed...
GPU_VIV_BIN_MX6Q_REDISTRIBUTE = NO

GPU_VIV_BIN_MX6Q_PROVIDES = libegl libgles

# DirectFB is not supported (wrong version)
ifeq ($(BR2_PACKAGE_XORG7),y)
GPU_VIV_BIN_MX6Q_DEPENDENCIES = xlib_libXdamage xlib_libXext
GPU_VIV_BIN_MX6Q_LIB_TARGET = x11
else
GPU_VIV_BIN_MX6Q_LIB_TARGET = fb
endif

# The archive is a shell-self-extractor of a bzipped tar. It happens
# to extract in the correct directory (gpu-viv-bin-mx6q-x.y.z)
# The --force makes sure it doesn't fail if the source dir already exists.
# The --auto-accept skips the license check - not needed for us
# because we have legal-info.
define GPU_VIV_BIN_MX6Q_EXTRACT_CMDS
	(cd $(BUILD_DIR); \
		sh $(DL_DIR)/$(GPU_VIV_BIN_MX6Q_SOURCE) --force --auto-accept)
endef

# Instead of building, we fix up the inconsistencies that exist
# in the upstream archive here.
# Make sure these commands are idempotent.
define GPU_VIV_BIN_MX6Q_BUILD_CMDS
	$(SED) 's/defined(LINUX)/defined(__linux__)/g' $(@D)/usr/include/*/*.h
	for lib in EGL GAL VIVANTE; do \
		ln -sf lib$${lib}-$(GPU_VIV_BIN_MX6Q_LIB_TARGET).so \
			$(@D)/usr/lib/lib$${lib}.so; \
	done
	ln -sf libGL.so.1.2 $(@D)/usr/lib/libGL.so.1
	ln -sf libGL.so.1.2 $(@D)/usr/lib/libGL.so
endef

define GPU_VIV_BIN_MX6Q_INSTALL_STAGING_CMDS
	cp -r $(@D)/usr/* $(STAGING_DIR)/usr
	for lib in egl glesv2 vg; do \
		$(INSTALL) -m 0644 -D \
			package/freescale-imx/gpu-viv-bin-mx6q/$${lib}.pc \
			$(STAGING_DIR)/usr/lib/pkgconfig/$${lib}.pc; \
		if [ "$(GPU_VIV_BIN_MX6Q_LIB_TARGET)" != "fb" ]; then \
			$(SED) "s/-DEGL_API_FB=1//" \
				$(STAGING_DIR)/usr/lib/pkgconfig/$${lib}.pc; \
		fi; \
	done
endef

ifeq ($(BR2_PACKAGE_GPU_VIV_BIN_MX6Q_EXAMPLES),y)
define GPU_VIV_BIN_MX6Q_INSTALL_EXAMPLES
	mkdir -p $(TARGET_DIR)/usr/share/examples/
	cp -r $(@D)/opt/* $(TARGET_DIR)/usr/share/examples/
endef
endif

# On the target, remove the unused libraries.
# Note that this is _required_, else ldconfig may create symlinks
# to the wrong library
define GPU_VIV_BIN_MX6Q_INSTALL_TARGET_CMDS
	$(GPU_VIV_BIN_MX6Q_INSTALL_EXAMPLES)
	cp -a $(@D)/usr/lib $(TARGET_DIR)/usr
	for lib in EGL GAL VIVANTE; do \
		for f in $(TARGET_DIR)/usr/lib/lib$${lib}-*.so; do \
			case $$f in \
				*-$(GPU_VIV_BIN_MX6Q_LIB_TARGET).so) : ;; \
				*) $(RM) $$f ;; \
			esac; \
		done; \
	done
endef

$(eval $(generic-package))
