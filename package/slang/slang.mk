################################################################################
#
# slang
#
################################################################################

SLANG_VERSION = 1.4.5
SLANG_SOURCE = slang-$(SLANG_VERSION)-mini.tar.bz2
SLANG_SITE = http://www.uclibc.org/
SLANG_INSTALL_STAGING = YES

# We need to add -fPIC since we're busting original CFLAGS
# that have it, see bug #3295
define SLANG_BUILD_CMDS
	$(MAKE1) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS) -fPIC" \
	LDFLAGS="$(TARGET_LDFLAGS)" -C $(@D)
endef

define SLANG_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0644 $(@D)/libslang.a $(STAGING_DIR)/usr/lib/libslang.a
	$(INSTALL) -D -m 0755 $(@D)/libslang.so $(STAGING_DIR)/usr/lib/libslang.so
	$(INSTALL) -D -m 0644 $(@D)/slang.h $(STAGING_DIR)/usr/include/slang.h
	$(INSTALL) -D -m 0644 $(@D)/slcurses.h $(STAGING_DIR)/usr/include/slcurses.h
	(cd $(STAGING_DIR)/usr/lib; ln -fs libslang.so libslang.so.1)
endef

define SLANG_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0644 $(@D)/libslang.a $(TARGET_DIR)/usr/lib/libslang.a
	$(INSTALL) -D -m 0755 $(@D)/libslang.so $(TARGET_DIR)/usr/lib/libslang.so
	$(INSTALL) -D -m 0644 $(@D)/slang.h $(TARGET_DIR)/usr/include/slang.h
	$(INSTALL) -D -m 0644 $(@D)/slcurses.h $(TARGET_DIR)/usr/include/slcurses.h
	(cd $(TARGET_DIR)/usr/lib; ln -fs libslang.so libslang.so.1)
endef

$(eval $(generic-package))
