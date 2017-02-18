################################################################################
#
# libcli
#
################################################################################

LIBCLI_VERSION = c63c9d35144939c8b4fa3c5394aed2e29ff517b0
LIBCLI_SITE = $(call github,dparrish,libcli,$(LIBCLI_VERSION))
LIBCLI_LICENSE = LGPLv2.1
LIBCLI_LICENSE_FILES = COPYING
LIBCLI_INSTALL_STAGING = YES

# We will pass optimisation level via CFLAGS so remove libcli default
LIBCLI_MAKE_ARGS += OPTIM=

# We can't run the test harness
LIBCLI_MAKE_ARGS += TESTS=

# Disable the static library for shared only build
ifeq ($(BR2_SHARED_LIBS),y)
LIBCLI_MAKE_ARGS += STATIC_LIB=
endif

# Disable the shared library for static only build
ifeq ($(BR2_STATIC_LIBS),y)
LIBCLI_MAKE_ARGS += DYNAMIC_LIB=
endif

define LIBCLI_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		$(LIBCLI_MAKE_ARGS)
endef

define LIBCLI_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		$(LIBCLI_MAKE_ARGS) DESTDIR=$(STAGING_DIR) PREFIX=/usr install
endef

define LIBCLI_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		$(LIBCLI_MAKE_ARGS) DESTDIR=$(TARGET_DIR) PREFIX=/usr install
endef

$(eval $(generic-package))
