################################################################################
#
# ti-gfx
#
################################################################################

TI_GFX_VERSION = 4_09_00_01
TI_GFX_SO_VERSION = 1.9.2188537

ifeq ($(BR2_ARM_EABIHF),y)
TI_GFX_SOURCE = Graphics_SDK_setuplinux_$(TI_GFX_VERSION)_hardfp_minimal_demos.bin
else
TI_GFX_SOURCE = Graphics_SDK_setuplinux_$(TI_GFX_VERSION)_minimal_demos.bin
endif

TI_GFX_SITE = http://downloads.ti.com/dsps/dsps_public_sw/sdo_sb/targetcontent/gfxsdk/$(TI_GFX_VERSION)/exports/
TI_GFX_LICENSE = Technology / Software Publicly Available
TI_GFX_LICENSE_FILES = TSPA.txt
TI_GFX_INSTALL_STAGING = YES

TI_GFX_DEPENDENCIES = linux

ifeq ($(BR2_PACKAGE_TI_GFX_ES3),y)
TI_GFX_OMAPES = 3.x
TI_GFX_PLATFORM = omap3
endif
ifeq ($(BR2_PACKAGE_TI_GFX_ES5),y)
TI_GFX_OMAPES = 5.x
TI_GFX_PLATFORM = omap3630
endif
ifeq ($(BR2_PACKAGE_TI_GFX_ES6),y)
TI_GFX_OMAPES = 6.x
TI_GFX_PLATFORM = ti81xx
endif
ifeq ($(BR2_PACKAGE_TI_GFX_ES8),y)
TI_GFX_OMAPES = 8.x
TI_GFX_PLATFORM = ti335x
endif

ifeq ($(BR2_PACKAGE_TI_GFX_DEBUG),y)
TI_GFX_DEBUG_LIB = dbg
TI_GFX_DEBUG_KM = debug
else
TI_GFX_DEBUG_LIB = rel
TI_GFX_DEBUG_KM = release
endif

TI_GFX_BIN_PATH = gfx_$(TI_GFX_DEBUG_LIB)_es$(TI_GFX_OMAPES)

TI_GFX_KM_MAKE_OPTS = \
	$(LINUX_MAKE_FLAGS) \
	BUILD=$(TI_GFX_DEBUG_KM) \
	TI_PLATFORM=$(TI_GFX_PLATFORM) \
	OMAPES=$(TI_GFX_OMAPES) \
	SUPPORT_XORG=0 \
	KERNELDIR=$(LINUX_DIR)

TI_GFX_DEMO_MAKE_OPTS = \
	PLATFORM=LinuxARMV7 \
	X11BUILD=0 \
	PLAT_CC="$(TARGET_CC)" \
	PLAT_CPP="$(TARGET_CXX)" \
	PLAT_AR="$(TARGET_AR)"

# The only required binary is pvrsrvctl all others are optional
TI_GFX_BIN = pvrsrvctl

ifeq ($(BR2_PACKAGE_TI_GFX_DEBUG),y)
TI_GFX_BIN += \
	eglinfo ews_server ews_server_es2 ews_test_gles1 ews_test_gles2 \
	ews_test_swrender gles1test1 gles2test1 pvr2d_test services_test \
	sgx_blit_test sgx_clipblit_test sgx_flip_test sgx_init_test \
	sgx_render_flip_test xeglinfo xgles1test1 xgles2test1 xmultiegltest
endif

TI_GFX_LIBS = \
	libews libpvr2d libpvrEWS_WSEGL libpvrPVR2D_BLITWSEGL libpvrPVR2D_DRIWSEGL \
	libpvrPVR2D_FLIPWSEGL libpvrPVR2D_FRONTWSEGL libpvrPVR2D_LINUXFBWSEGL \
	libPVRScopeServices libsrv_init libsrv_um libusc pvr_drv

TI_GFX_EGLIMAGE_LIBS = \
	libEGL libGLES_CM libGLESv2 libglslcompiler libIMGegl

TI_GFX_DEMOS = ChameleonMan MagicLantern
TI_GFX_DEMOS_LOC = GFX_Linux_SDK/OGLES2/SDKPackage/Demos
TI_GFX_DEMOS_MAKE_LOC = OGLES2/Build/LinuxGeneric
TI_GFX_DEMOS_BIN_LOC = OGLES2/Build/LinuxARMV7/ReleaseRaw/

TI_GFX_HDR_DIRS = OGLES2/EGL OGLES2/EWS OGLES2/GLES2 OGLES2/KHR \
	OGLES/GLES bufferclass_ti/ pvr2d/ wsegl/

define TI_GFX_EXTRACT_CMDS
	$(RM) -rf $(TI_GFX_DIR)
	chmod +x $(DL_DIR)/$(TI_GFX_SOURCE)
	printf "Y\nY\n qY\n\n" | $(DL_DIR)/$(TI_GFX_SOURCE) \
		--prefix $(@D) \
		--mode console
endef

define TI_GFX_BUILD_KM_CMDS
	$(MAKE) $(TI_GFX_KM_MAKE_OPTS) -C $(@D)/GFX_Linux_KM all
endef

ifeq ($(BR2_PACKAGE_TI_GFX_DEMOS),y)
define TI_GFX_BUILD_DEMO_CMDS
	$(foreach demo, $(TI_GFX_DEMOS), \
		$(TARGET_MAKE_ENV) $(MAKE1) -C \
			$(@D)/$(TI_GFX_DEMOS_LOC)/$(demo)/$(TI_GFX_DEMOS_MAKE_LOC) \
			$(TI_GFX_DEMO_MAKE_OPTS) all
	)
endef
endif

define TI_GFX_BUILD_CMDS
	$(TI_GFX_BUILD_KM_CMDS)
	$(TI_GFX_BUILD_DEMO_CMDS)
endef

# Install libs
# argument 1 is the location to install to (e.g. STAGING_DIR, TARGET_DIR)
define TI_GFX_INSTALL_LIBS
	$(foreach lib,$(TI_GFX_LIBS),
		$(INSTALL) -D -m 0644 $(@D)/$(TI_GFX_BIN_PATH)/$(lib).so \
			$(1)/usr/lib/$(lib).so.$(TI_GFX_SO_VERSION); \
		ln -sf $(lib).so.$(TI_GFX_SO_VERSION) \
			$(1)/usr/lib/$(lib).so
	)
	$(foreach lib,$(TI_GFX_EGLIMAGE_LIBS),
		$(if $(BR2_PACKAGE_TI_GFX_EGLIMAGE),
			$(INSTALL) -D -m 0644 $(@D)/$(TI_GFX_BIN_PATH)/$(lib)_eglimage.so \
				$(1)/usr/lib/$(lib).so.$(TI_GFX_SO_VERSION);
		,
			$(INSTALL) -D -m 0644 $(@D)/$(TI_GFX_BIN_PATH)/$(lib).so \
				$(1)/usr/lib/$(lib).so.$(TI_GFX_SO_VERSION);
		)
		ln -sf $(lib).so.$(TI_GFX_SO_VERSION) \
			$(1)/usr/lib/$(lib).so
	)
endef

define TI_GFX_INSTALL_STAGING_CMDS
	$(foreach incdir,$(TI_GFX_HDR_DIRS),
		$(INSTALL) -d $(STAGING_DIR)/usr/include/$(notdir $(incdir)); \
		$(INSTALL) -D -m 0644 $(@D)/include/$(incdir)/*.h \
			$(STAGING_DIR)/usr/include/$(notdir $(incdir))/
	)
	$(call TI_GFX_INSTALL_LIBS,$(STAGING_DIR))

	$(INSTALL) -D -m 0644 package/ti-gfx/egl.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/egl.pc
	$(INSTALL) -D -m 0644 package/ti-gfx/glesv2.pc \
		$(STAGING_DIR)/usr/lib/pkgconfig/glesv2.pc
endef

define TI_GFX_INSTALL_KM_CMDS
	$(MAKE) $(TI_GFX_KM_MAKE_OPTS) -C $(@D)/GFX_Linux_KM install
endef

define TI_GFX_INSTALL_BINS_CMDS
	$(foreach bin,$(TI_GFX_BIN),
		$(INSTALL) -D -m 0755 $(@D)/$(TI_GFX_BIN_PATH)/$(bin) \
			$(TARGET_DIR)/usr/bin/$(bin)
	)
	$(if $(BR2_PACKAGE_TI_GFX_DEBUG),
		$(INSTALL) -D -m 0755 package/ti-gfx/esrev.sh \
			$(TARGET_DIR)/usr/sbin/esrev
	)
endef

define TI_GFX_INSTALL_CONF_CMDS
	# libs use the following file for configuration.
	$(INSTALL) -D -m 0644 package/ti-gfx/powervr.ini \
		$(TARGET_DIR)/etc/powervr.ini
endef

ifeq ($(BR2_PACKAGE_TI_GFX_DEMOS),y)
define TI_GFX_INSTALL_DEMOS_CMDS
	$(foreach demo,$(TI_GFX_DEMOS),
		$(INSTALL) -D -m 0755 \
		$(@D)/$(TI_GFX_DEMOS_LOC)/$(demo)/$(TI_GFX_DEMOS_BIN_LOC)/OGLES2$(demo) \
		$(TARGET_DIR)/usr/bin/OGLES2$(demo)
	)
endef
endif

define TI_GFX_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/ti-gfx/S80ti-gfx \
		$(TARGET_DIR)/etc/init.d/S80ti-gfx
endef

define TI_GFX_INSTALL_TARGET_CMDS
	$(TI_GFX_INSTALL_KM_CMDS)
	$(TI_GFX_INSTALL_BINS_CMDS)
	$(call TI_GFX_INSTALL_LIBS,$(TARGET_DIR))
	$(TI_GFX_INSTALL_CONF_CMDS)
	$(TI_GFX_INSTALL_DEMOS_CMDS)
endef

$(eval $(generic-package))
