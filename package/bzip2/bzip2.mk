#############################################################
#
# bzip2
#
#############################################################

BZIP2_VERSION = 1.0.6
BZIP2_SITE = http://www.bzip.org/$(BZIP2_VERSION)
BZIP2_INSTALL_STAGING = YES
BZIP2_LICENSE = bzip2 license
BZIP2_LICENSE_FILES = LICENSE

define BZIP2_FIX_MAKEFILE
	$(SED) "s,ln \$$(,ln -snf \$$(,g" $(@D)/Makefile
	$(SED) "s,ln -s (lib.*),ln -snf \$$1; ln -snf libbz2.so.$(BZIP2_VERSION)) \
	    libbz2.so,g" $(@D)/Makefile-libbz2_so
	$(SED) "s:-O2:$(TARGET_CFLAGS):" $(@D)/Makefile
	$(SED) "s:-O2:$(TARGET_CFLAGS):" $(@D)/Makefile-libbz2_so
endef

BZIP2_POST_PATCH_HOOKS += BZIP2_FIX_MAKEFILE

define BZIP2_NOLARGEFILE_FIX_MAKEFILE
	$(SED) "s,^BIGFILES,#BIGFILES,g" $(@D)/Makefile
	$(SED) "s,^BIGFILES,#BIGFILES,g" $(@D)/Makefile-libbz2_so
endef

ifneq ($(BR2_LARGEFILE),y)
BZIP2_POST_PATCH_HOOKS += BZIP2_NOLARGEFILE_FIX_MAKEFILE
endif

define BZIP2_BUILD_CMDS
	$(TARGET_MAKE_ENV) \
	$(MAKE) -C $(@D) -f Makefile-libbz2_so \
	CC="$(TARGET_CC)" RANLIB="$(TARGET_RANLIB)" AR="$(TARGET_AR)"
	$(TARGET_MAKE_ENV) \
	$(MAKE) -C $(@D) \
	CC="$(TARGET_CC)" RANLIB="$(TARGET_RANLIB)" AR="$(TARGET_AR)" \
	libbz2.a bzip2 bzip2recover
endef

define BZIP2_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
	$(MAKE) PREFIX=$(STAGING_DIR)/usr -C $(@D) install
	$(INSTALL) -m 0755 -d $(STAGING_DIR)/usr/lib
	cp $(@D)/libbz2.so.$(BZIP2_VERSION) $(STAGING_DIR)/usr/lib/
	cp $(@D)/libbz2.a $(STAGING_DIR)/usr/lib/
	(cd $(STAGING_DIR)/usr/lib/; \
		ln -snf libbz2.so.$(BZIP2_VERSION) libbz2.so; \
		ln -snf libbz2.so.$(BZIP2_VERSION) libbz2.so.1.0; \
		ln -snf libbz2.so.$(BZIP2_VERSION) libbz2.so.1; \
	)
endef

# make sure busybox doesn't get overwritten by make install
define BZIP2_INSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,bzip2 bunzip2 bzcat)
	$(TARGET_MAKE_ENV) $(TARGET_CONFIGURE_OPTS) \
	$(MAKE) PREFIX=$(TARGET_DIR)/usr -C $(@D) install
	cp $(@D)/libbz2.so.$(BZIP2_VERSION) $(TARGET_DIR)/usr/lib/
	(cd $(TARGET_DIR)/usr/lib; \
		ln -snf libbz2.so.$(BZIP2_VERSION) libbz2.so.1.0; \
		ln -snf libbz2.so.$(BZIP2_VERSION) libbz2.so.1; \
		ln -snf libbz2.so.$(BZIP2_VERSION) libbz2.so; \
	)
	(cd $(TARGET_DIR)/usr/bin; \
		ln -snf bzip2 bunzip2; \
		ln -snf bzip2 bzcat; \
		ln -snf bzdiff bzcmp; \
		ln -snf bzmore bzless; \
		ln -snf bzgrep bzegrep; \
		ln -snf bzgrep bzfgrep; \
	)
endef

define BZIP2_CLEAN_CMDS
	rm -f $(addprefix $(TARGET_DIR),/lib/libbz2.* \
					/usr/lib/libbz2.* \
					/usr/include/bzlib.h)
	rm -f $(addprefix $(STAGING_DIR),/lib/libbz2.* \
					/usr/lib/libbz2.* \
					/usr/include/bzlib.h)
	-$(MAKE) -C $(@D) clean
endef

define HOST_BZIP2_FIX_MAKEFILE
	$(SED) "s,ln \$$(,ln -snf \$$(,g" $(@D)/Makefile
	$(SED) "s,ln -s (lib.*),ln -snf \$$1; ln -snf libbz2.so.$(BZIP2_VERSION) \
	    libbz2.so,g" $(@D)/Makefile-libbz2_so
	$(SED) "s:-O2:$(HOST_CFLAGS):" $(@D)/Makefile
	$(SED) "s:-O2:$(HOST_CFLAGS):" $(@D)/Makefile-libbz2_so
endef

HOST_BZIP2_POST_PATCH_HOOKS += HOST_BZIP2_FIX_MAKEFILE

define HOST_BZIP2_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) -f Makefile-libbz2_so
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) libbz2.a bzip2 bzip2recover
endef

define HOST_BZIP2_INSTALL_CMDS
	$(HOST_MAKE_ENV) \
	$(MAKE) PREFIX=$(HOST_DIR)/usr -C $(@D) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
