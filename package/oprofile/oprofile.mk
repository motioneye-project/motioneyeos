#############################################################
#
# oprofile
#
#############################################################
OPROFILE_VERSION := 0.9.6
OPROFILE_CONF_OPT :=	--localstatedir=/var \
			--with-kernel-support

OPROFILE_BINARIES := utils/ophelp
OPROFILE_BINARIES += pp/opannotate pp/oparchive pp/opgprof pp/opreport opjitconv/opjitconv
OPROFILE_BINARIES += daemon/oprofiled

ifeq ($(BR2_powerpc),y)
OPROFILE_ARCH := ppc
endif
ifeq ($(BR2_x86_64),y)
OPROFILE_ARCH := x86-64
endif
ifeq ($(OPROFILE_ARCH),)
OPROFILE_ARCH := $(BR2_ARCH)
endif

OPROFILE_DEPENDENCIES := popt binutils

define OPROFILE_INSTALL_TARGET_CMDS
	$(INSTALL) -d -m 755 $(TARGET_DIR)/usr/bin
	$(INSTALL) -d -m 755 $(TARGET_DIR)/usr/share/oprofile
	cp -dpfr $(@D)/events/$(OPROFILE_ARCH) $(TARGET_DIR)/usr/share/oprofile
	$(INSTALL) -m 644 $(@D)/libregex/stl.pat $(TARGET_DIR)/usr/share/oprofile
	$(INSTALL) -m 755 $(@D)/utils/opcontrol $(TARGET_DIR)/usr/bin
	$(INSTALL) -m 755 $(addprefix $(@D)/, $(OPROFILE_BINARIES)) $(TARGET_DIR)/usr/bin
endef

define OPROFILE_UNINSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/, $(notdir $(OPROFILE_BINARIES)))
	rm -f $(TARGET_DIR)/usr/bin/opcontrol
	rm -rf $(TARGET_DIR)/usr/share/oprofile
endef

$(eval $(call AUTOTARGETS,package,oprofile))
