################################################################################
#
# libsepol
#
################################################################################

LIBSEPOL_VERSION = 2.5
LIBSEPOL_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20160223
LIBSEPOL_LICENSE = LGPLv2.1+
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
	$(MAKE) -C $(@D) $(LIBSEPOL_MAKE_FLAGS) DESTDIR=$(STAGING_DIR)
endef

define LIBSEPOL_INSTALL_STAGING_CMDS
	$(MAKE) -C $(@D) install $(LIBSEPOL_MAKE_FLAGS) DESTDIR=$(STAGING_DIR)
endef

define LIBSEPOL_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) install $(LIBSEPOL_MAKE_FLAGS) DESTDIR=$(TARGET_DIR)
endef

define HOST_LIBSEPOL_BUILD_CMDS
	$(MAKE) -C $(@D) $(HOST_CONFIGURE_OPTS) DESTDIR=$(HOST_DIR)
endef

define HOST_LIBSEPOL_INSTALL_CMDS
	$(MAKE) -C $(@D) install $(HOST_CONFIGURE_OPTS) DESTDIR=$(HOST_DIR)
	mv $(HOST_DIR)/lib/libsepol.so.1 $(HOST_DIR)/usr/lib
	(cd $(HOST_DIR)/usr/lib; rm -f libsepol.so; ln -s libsepol.so.1 libsepol.so)
	-rmdir $(HOST_DIR)/lib
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
