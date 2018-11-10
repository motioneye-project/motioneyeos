################################################################################
#
# checkpolicy
#
################################################################################

CHECKPOLICY_VERSION = 2.7
CHECKPOLICY_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20170804
CHECKPOLICY_LICENSE = GPL-2.0
CHECKPOLICY_LICENSE_FILES = COPYING

CHECKPOLICY_DEPENDENCIES = libselinux flex host-flex host-bison

CHECKPOLICY_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS) \
	LEX="$(HOST_DIR)/bin/flex" \
	YACC="$(HOST_DIR)/bin/bison -y"

# DESTDIR is used at build time to find libselinux
define CHECKPOLICY_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(CHECKPOLICY_MAKE_OPTS) DESTDIR=$(STAGING_DIR)
endef

define CHECKPOLICY_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(CHECKPOLICY_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install

endef

define CHECKPOLICY_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) $(CHECKPOLICY_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install
endef

HOST_CHECKPOLICY_DEPENDENCIES = host-libselinux host-flex host-bison

# PREFIX is used at build time to find host-libselinux
HOST_CHECKPOLICY_MAKE_OPTS = \
	$(HOST_CONFIGURE_OPTS) \
	PREFIX=$(HOST_DIR) \
	LEX="$(HOST_DIR)/bin/flex" \
	YACC="$(HOST_DIR)/bin/bison -y"

define HOST_CHECKPOLICY_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_CHECKPOLICY_MAKE_OPTS)
endef

define HOST_CHECKPOLICY_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_CHECKPOLICY_MAKE_OPTS) install
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
