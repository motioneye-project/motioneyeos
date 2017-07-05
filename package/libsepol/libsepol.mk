################################################################################
#
# libsepol
#
################################################################################

LIBSEPOL_VERSION = 2.6
LIBSEPOL_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20161014
LIBSEPOL_LICENSE = LGPL-2.1+
LIBSEPOL_LICENSE_FILES = COPYING

LIBSEPOL_INSTALL_STAGING = YES
LIBSEPOL_DEPENDENCIES = host-flex
HOST_LIBSEPOL_DEPENDENCIES = host-flex

LIBSEPOL_MAKE_FLAGS = $(TARGET_CONFIGURE_OPTS)

ifeq ($(BR2_STATIC_LIBS),y)
LIBSEPOL_MAKE_FLAGS += STATIC=1
endif

define LIBSEPOL_BUILD_CMDS
	# DESTDIR is needed during the compile to compute library and
	# header paths.
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(LIBSEPOL_MAKE_FLAGS) DESTDIR=$(STAGING_DIR)
endef

define LIBSEPOL_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install $(LIBSEPOL_MAKE_FLAGS) DESTDIR=$(STAGING_DIR)
endef

define LIBSEPOL_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install $(LIBSEPOL_MAKE_FLAGS) DESTDIR=$(TARGET_DIR)
endef

HOST_LIBSEPOL_MAKE_ENV = \
	$(HOST_MAKE_ENV) \
	DESTDIR=$(HOST_DIR) \
	PREFIX=$(HOST_DIR)

define HOST_LIBSEPOL_BUILD_CMDS
	$(HOST_LIBSEPOL_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_CONFIGURE_OPTS)
endef

define HOST_LIBSEPOL_INSTALL_CMDS
	$(HOST_LIBSEPOL_MAKE_ENV) $(MAKE) -C $(@D) install $(HOST_CONFIGURE_OPTS)
	ln -sf libsepol.so.1 $(HOST_DIR)/lib/libsepol.so
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
