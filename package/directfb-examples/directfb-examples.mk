#############################################################
#
# directfb examples
#
#############################################################
DIRECTFB_EXAMPLES_VERSION:=1.2.0
DIRECTFB_EXAMPLES_SITE:=http://www.directfb.org/downloads/Extras
DIRECTFB_EXAMPLES_SOURCE = DirectFB-examples-$(DIRECTFB_EXAMPLES_VERSION).tar.gz
DIRECTFB_EXAMPLES_INSTALL_STAGING = YES
DIRECTFB_EXAMPLES_INSTALL_TARGET = YES
DIRECTFB_EXAMPLES_DEPENDENCIES = directfb

DIRECTFB_EXAMPLES_TARGETS_ :=
DIRECTFB_EXAMPLES_TARGETS_y :=

DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_ANDI) += usr/bin/df_andi
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_BLTLOAD) += usr/bin/df_bltload
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_CPULOAD) += usr/bin/df_cpuload
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_DATABUFFER) += usr/bin/df_databuffer
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_DIOLOAD) += usr/bin/df_dioload
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_DOK) += usr/bin/df_dok
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_DRIVERTEST) += usr/bin/df_drivertest
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_FIRE) += usr/bin/df_fire
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_FLIP) += usr/bin/df_flip
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_FONTS) += usr/bin/df_fonts
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_INPUT) += usr/bin/df_input
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_JOYSTICK) += usr/bin/df_joystick
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_KNUCKLES) += usr/bin/df_knuckles
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_LAYER) += usr/bin/df_layer
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_NEO) += usr/bin/df_neo
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_NETLOAD) += usr/bin/df_netload
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_PALETTE) += usr/bin/df_palette
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_PARTICLE) += usr/bin/df_particle
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_PORTER) += usr/bin/df_porter
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_STRESS) += usr/bin/df_stress
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_TEXTURE) += usr/bin/df_texture
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_VIDEO) += usr/bin/df_video
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_VIDEO_PARTICLE) += usr/bin/df_video_particle
DIRECTFB_EXAMPLES_TARGETS_$(BR2_PACKAGE_DIRECTFB_EXAMPLES_WINDOW) += usr/bin/df_window

$(eval $(call AUTOTARGETS,package,directfb-examples))

$(DIRECTFB_EXAMPLES_TARGET_INSTALL_TARGET): $(DIRECTFB_EXAMPLES_TARGET_INSTALL_STAGING)
	$(call MESSAGE,"Installing to target")
	$(MAKE) DESTDIR=$(STAGING_DIR) -C $(DIRECTFB_EXAMPLES_DIR) install
	$(Q)mkdir -p $(TARGET_DIR)/usr/bin
	$(Q)mkdir -p $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)mkdir -p $(TARGET_DIR)/usr/share/directfb-examples/fonts/
	for file in $(DIRECTFB_EXAMPLES_TARGETS_y); do \
	        cp -dpf $(STAGING_DIR)/$$file $(TARGET_DIR)/$$file; \
	done

	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/fonts/decker.ttf $(TARGET_DIR)/usr/share/directfb-examples/fonts/
ifeq ($(BR2_PACKAGE_DIRECTFB_EXAMPLES_ANDI),y)
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/destination_mask.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/tux.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/wood_andi.jpg $(TARGET_DIR)/usr/share/directfb-examples/
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_EXAMPLES_DOK),y)
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/biglogo.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/card.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/melted.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/meter.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/pngtest*.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/colorkeyed.gif $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/intro.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/fish.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/swirl.png $(TARGET_DIR)/usr/share/directfb-examples/
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_EXAMPLES_DRIVERTEST),y)
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/pngtest.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/testmask.png $(TARGET_DIR)/usr/share/directfb-examples/
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_EXAMPLES_FONTS),y)
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/fonts/* $(TARGET_DIR)/usr/share/directfb-examples/fonts/
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_EXAMPLES_INPUT),y)
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/joystick.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/gnu-keys.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/gnome-mouse.png $(TARGET_DIR)/usr/share/directfb-examples/
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_EXAMPLES_NEO),y)
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/apple-red.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/gnome-*.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/gnu-*.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/background*.jpg $(TARGET_DIR)/usr/share/directfb-examples/
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_EXAMPLES_STRESS),y)
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/melted.png $(TARGET_DIR)/usr/share/directfb-examples/
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_EXAMPLES_TEXTURE),y)
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/texture.png $(TARGET_DIR)/usr/share/directfb-examples/
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_EXAMPLES_VIDEO),y)
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/shot.png $(TARGET_DIR)/usr/share/directfb-examples/
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_EXAMPLES_VIDEO_PARTICLE),y)
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/convergence.png $(TARGET_DIR)/usr/share/directfb-examples/
endif
ifeq ($(BR2_PACKAGE_DIRECTFB_EXAMPLES_WINDOW),y)
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/desktop.png $(TARGET_DIR)/usr/share/directfb-examples/
	$(Q)cp -rdpf $(STAGING_DIR)/usr/share/directfb-examples/dfblogo.png $(TARGET_DIR)/usr/share/directfb-examples/
endif
	$(Q)touch -c $@

