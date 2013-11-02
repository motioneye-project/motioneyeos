################################################################################
#
# linenoise
#
################################################################################

LINENOISE_VERSION = 27a3b4d5205a5fb3e2101128edd6653bd0c92189
LINENOISE_SITE = http://github.com/antirez/linenoise/tarball/$(LINENOISE_VERSION)
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

define LINENOISE_UNINSTALL_STAGING_CMDS
	rm -f   $(STAGING_DIR)/usr/include/linenoise.h
	rm -f   $(STAGING_DIR)/usr/lib/liblinenoise.a
	rm -f   $(STAGING_DIR)/usr/bin/linenoise_example
endef

define LINENOISE_INSTALL_TARGET_CMDS
	$(INSTALL) -m 644 -D $(@D)/linenoise.h          $(TARGET_DIR)/usr/include/linenoise.h
	$(INSTALL) -m 644 -D $(@D)/liblinenoise.a       $(TARGET_DIR)/usr/lib/liblinenoise.a
	$(INSTALL) -m 755 -D $(@D)/linenoise_example    $(TARGET_DIR)/usr/bin/linenoise_example
endef

define LINENOISE_UNINSTALL_TARGET_CMDS
	rm -f   $(TARGET_DIR)/usr/include/linenoise.h
	rm -f   $(TARGET_DIR)/usr/lib/liblinenoise.a
	rm -f   $(TARGET_DIR)/usr/bin/linenoise_example
endef

define LINENOISE_CLEAN_CMDS
	rm -f $(@D)/*.o $(@D)/*.a $(@D)/linenoise_example
endef

$(eval $(generic-package))
