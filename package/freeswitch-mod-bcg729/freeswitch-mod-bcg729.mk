################################################################################
#
# freeswitch-mod-bcg729
#
################################################################################

FREESWITCH_MOD_BCG729_VERSION = c504eea91f225014380ae17c00b35e7173e316ad
FREESWITCH_MOD_BCG729_SITE = $(call github,xadhoom,mod_bcg729,$(FREESWITCH_MOD_BCG729_VERSION))
FREESWITCH_MOD_BCG729_LICENSE = MPL-1.1
FREESWITCH_MOD_BCG729_LICENSE_FILES = LICENSE
FREESWITCH_MOD_BCG729_DEPENDENCIES = freeswitch bcg729

# instead of patching the not cross-compile friendly Makefile from
# upstream we issue the necessary build commands ourselves
define FREESWITCH_MOD_BCG729_BUILD_CMDS
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-I$(STAGING_DIR)/usr/include/freeswitch \
		-fPIC -fomit-frame-pointer -fno-exceptions \
		-c $(@D)/mod_bcg729.c -o $(@D)/mod_bcg729.o
	$(TARGET_CC) $(TARGET_CFLAGS) $(TARGET_LDFLAGS) \
		-fPIC -fomit-frame-pointer -fno-exceptions \
		-shared -Xlinker -x -lm -lbcg729 -Wl,-Bdynamic \
		-o $(@D)/mod_bcg729.so $(@D)/mod_bcg729.o
endef

define FREESWITCH_MOD_BCG729_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 $(@D)/mod_bcg729.so $(TARGET_DIR)/usr/lib/freeswitch/mod/mod_bcg729.so
endef

$(eval $(generic-package))
