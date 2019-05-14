################################################################################
#
# libsepol
#
################################################################################

LIBSEPOL_VERSION = 2.8
LIBSEPOL_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20180524
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
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(LIBSEPOL_MAKE_FLAGS)
endef

# Set SHLIBDIR to /usr/lib so it has the same value than LIBDIR, as a result
# we won't have to use a relative path in 0002-revert-ln-relative.patch
define LIBSEPOL_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install $(LIBSEPOL_MAKE_FLAGS) \
		DESTDIR=$(STAGING_DIR) SHLIBDIR=/usr/lib
endef

define LIBSEPOL_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) install $(LIBSEPOL_MAKE_FLAGS) \
		DESTDIR=$(TARGET_DIR) SHLIBDIR=/usr/lib
endef

HOST_LIBSEPOL_MAKE_ENV = \
	$(HOST_MAKE_ENV) \
	PREFIX=$(HOST_DIR) \
	SHLIBDIR=$(HOST_DIR)/lib

define HOST_LIBSEPOL_BUILD_CMDS
	$(HOST_LIBSEPOL_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_CONFIGURE_OPTS)
endef

define HOST_LIBSEPOL_INSTALL_CMDS
	$(HOST_LIBSEPOL_MAKE_ENV) $(MAKE) -C $(@D) install $(HOST_CONFIGURE_OPTS)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
