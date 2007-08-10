#############################################################
#
# mesa3d
#
#############################################################
MESA3D_VERSION:=6.5.3
#MESA3D_VERSION:=6.4.2
MESA3D_SOURCE:=MesaLib-$(MESA3D_VERSION).tar.gz
MESA3D_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/mesa3d
MESA3D_DIR:=$(BUILD_DIR)/Mesa-$(MESA3D_VERSION)
MESA_TARGET=linux-dri-x86
MESA_BUILD_ENV=$(TARGET_CONFIGURE_OPTS)
MESA_CONFIG_FILE=$(MESA3D_DIR)/configs/$(MESA_TARGET)
#MESA_DRIVERS= i810 i915 i965 mga mach64 r128 r200 r300 s3v savage sis ffb tdfx trident unichrome
MESA_DRIVERS=

$(DL_DIR)/$(MESA3D_SOURCE):
	$(WGET) -P $(DL_DIR) $(MESA3D_SITE)/$(MESA3D_SOURCE)

$(MESA3D_DIR)/.extracted: $(DL_DIR)/$(MESA3D_SOURCE)
	$(ZCAT) $(DL_DIR)/$(MESA3D_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(MESA3D_DIR) package/mesa3d/ mesa3d\*.patch
	touch $@

$(MESA3D_DIR)/.configured: $(MESA3D_DIR)/.extracted
	( export $(TARGET_CONFIGURE_OPTS) ; \
		echo "DRI_DIRS = $(MESA_DRIVERS)" && \
		echo "OPT_FLAGS = $(TARGET_CFLAGS)" && \
		echo "CC = $(TARGET_CC)" && \
		echo "CXX = $(TARGET_CXX)" && \
		echo "PIC_FLAGS = -fPIC" && \
		echo "SRC_DIRS = glx/x11 mesa glu glut/glx" && \
		echo "USING_EGL = 0" && \
		echo "X11_INCLUDES = " && \
		echo "EXTRA_LIB_PATH = " && \
		echo "PROGRAM_DIRS =" \
	) >> $(MESA_CONFIG_FILE)
	touch $@

$(MESA3D_DIR)/.built: BR2_JLEVEL=1
$(MESA3D_DIR)/.built: $(MESA3D_DIR)/.configured
	gccinc=$$($(TARGET_CC) -print-search-dirs | grep '^install:' | sed 's@^install: @@')include ; \
	rm -f $(MESA3D_DIR)/config/current
	env $(MESA_BUILD_ENV) $(MAKE) \
		MKDEP="makedepend -I$$gccinc" \
		CC=$(TARGET_CC) CXX=$(TARGET_CXX) CC_FOR_BUILD=/usr/bin/gcc \
		-C $(MESA3D_DIR) $(MESA_TARGET)
	touch $@

$(MESA3D_DIR)/.installed: $(MESA3D_DIR)/.built
	env $(MESA_BUILD_ENV) $(MAKE) \
		INSTALL_DIR=$(STAGING_DIR)/usr \
		DRI_DRIVER_INSTALL_DIR=$(STAGING_DIR)/usr/lib/dri \
		-C $(MESA3D_DIR) install
	env $(MESA_BUILD_ENV) $(MAKE) \
		INSTALL_DIR=$(TARGET_DIR)/usr \
		DRI_DRIVER_INSTALL_DIR=$(TARGET_DIR)/usr/lib/dri \
		-C $(MESA3D_DIR) install
	rm -Rf $(TARGET_DIR)/usr/include/GL
	touch $@

mesa3d-depends:   xproto_glproto xproto_xf86vidmodeproto xlib_libXxf86vm xlib_libXmu xlib_libXdamage libdrm
mesa3d-source:    $(MESA3D_DIR)/.extracted
mesa3d-configure: $(MESA3D_DIR)/.configured
mesa3d-build:     $(MESA3D_DIR)/.built
mesa3d:           mesa3d-depends $(MESA3D_DIR)/.installed	

mesa3d-clean:
	$(MAKE) prefix=$(STAGING_DIR)/usr -C $(MESA3D_DIR) uninstall
	$(MAKE) prefix=$(TARGET_DIR)/usr  -C $(MESA3D_DIR) uninstall
	-$(MAKE) -C $(MESA3D_DIR) clean

mesa3d-dirclean:
	rm -rf $(MESA3D_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_MESA3D)),y)
TARGETS+=mesa3d
endif
# :mode=makefile:

