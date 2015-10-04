################################################################################
#
# bzip2
#
################################################################################

BZIP2_VERSION = 1.0.6
BZIP2_SITE = http://www.bzip.org/$(BZIP2_VERSION)
BZIP2_INSTALL_STAGING = YES
BZIP2_LICENSE = bzip2 license
BZIP2_LICENSE_FILES = LICENSE

ifeq ($(BR2_STATIC_LIBS),)
define BZIP2_BUILD_SHARED_CMDS
	$(TARGET_MAKE_ENV)
		$(MAKE) -C $(@D) -f Makefile-libbz2_so $(TARGET_CONFIGURE_OPTS)
endef
endif

define BZIP2_BUILD_CMDS
	$(TARGET_MAKE_ENV)
		$(MAKE) -C $(@D) libbz2.a bzip2 bzip2recover $(TARGET_CONFIGURE_OPTS)
	$(BZIP2_BUILD_SHARED_CMDS)
endef

ifeq ($(BR2_STATIC_LIBS),)
define BZIP2_INSTALL_STAGING_SHARED_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
		-f Makefile-libbz2_so PREFIX=$(STAGING_DIR)/usr -C $(@D) install
endef
endif

define BZIP2_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
		PREFIX=$(STAGING_DIR)/usr -C $(@D) install
	$(BZIP2_INSTALL_STAGING_SHARED_CMDS)
endef

ifeq ($(BR2_STATIC_LIBS),)
define BZIP2_INSTALL_TARGET_SHARED_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
		-f Makefile-libbz2_so PREFIX=$(TARGET_DIR)/usr -C $(@D) install
endef
endif

# make sure busybox doesn't get overwritten by make install
define BZIP2_INSTALL_TARGET_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,bzip2 bunzip2 bzcat)
	$(TARGET_MAKE_ENV) $(MAKE) \
		PREFIX=$(TARGET_DIR)/usr -C $(@D) install
	$(BZIP2_INSTALL_TARGET_SHARED_CMDS)
endef

define HOST_BZIP2_BUILD_CMDS
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) -f Makefile-libbz2_so
	$(HOST_MAKE_ENV) $(HOST_CONFIGURE_OPTS) \
		$(MAKE) -C $(@D) libbz2.a bzip2 bzip2recover
endef

define HOST_BZIP2_INSTALL_CMDS
	$(HOST_MAKE_ENV) \
		$(MAKE) PREFIX=$(HOST_DIR)/usr -C $(@D) install
	$(HOST_MAKE_ENV) \
		$(MAKE) -f Makefile-libbz2_so PREFIX=$(HOST_DIR)/usr -C $(@D) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
