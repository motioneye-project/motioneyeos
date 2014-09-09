################################################################################
#
# linenoise
#
################################################################################

LINENOISE_VERSION = 828b9dacc52d4ad5a15c89be8fb8691d224f9a4f
LINENOISE_SITE = $(call github,antirez,linenoise,$(LINENOISE_VERSION))
LINENOISE_LICENSE = BSD-2c
LINENOISE_INSTALL_STAGING = YES

define LINENOISE_BUILD_CMDS
	cd $(@D); $(TARGET_CC) $(TARGET_CFLAGS) -c linenoise.c
	cd $(@D); $(TARGET_AR) rcu liblinenoise.a linenoise.o
	cd $(@D); $(TARGET_CC) $(TARGET_LDFLAGS) -o linenoise_example example.c -L. -llinenoise
endef

define LINENOISE_INSTALL_STAGING_CMDS
	$(INSTALL) -m 644 -D $(@D)/linenoise.h          $(STAGING_DIR)/usr/include/linenoise.h
	$(INSTALL) -m 644 -D $(@D)/liblinenoise.a       $(STAGING_DIR)/usr/lib/liblinenoise.a
	$(INSTALL) -m 755 -D $(@D)/linenoise_example    $(STAGING_DIR)/usr/bin/linenoise_example
endef

define LINENOISE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 644 -D $(@D)/linenoise.h          $(TARGET_DIR)/usr/include/linenoise.h
	$(INSTALL) -m 644 -D $(@D)/liblinenoise.a       $(TARGET_DIR)/usr/lib/liblinenoise.a
	$(INSTALL) -m 755 -D $(@D)/linenoise_example    $(TARGET_DIR)/usr/bin/linenoise_example
endef

$(eval $(generic-package))
