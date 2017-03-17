################################################################################
#
# checkpolicy
#
################################################################################

CHECKPOLICY_VERSION = 2.6
CHECKPOLICY_SITE = https://raw.githubusercontent.com/wiki/SELinuxProject/selinux/files/releases/20161014
CHECKPOLICY_LICENSE = GPLv2
CHECKPOLICY_LICENSE_FILES = COPYING

HOST_CHECKPOLICY_DEPENDENCIES = host-libselinux host-flex host-bison

HOST_CHECKPOLICY_MAKE_OPTS = $(HOST_CONFIGURE_OPTS) \
	LEX="$(HOST_DIR)/usr/bin/flex" \
	YACC="$(HOST_DIR)/usr/bin/bison -y"

# DESTDIR is used at build time to find host-libselinux
define HOST_CHECKPOLICY_BUILD_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_CHECKPOLICY_MAKE_OPTS) DESTDIR=$(HOST_DIR)
endef

define HOST_CHECKPOLICY_INSTALL_CMDS
	$(HOST_MAKE_ENV) $(MAKE) -C $(@D) $(HOST_CHECKPOLICY_MAKE_OPTS) DESTDIR=$(HOST_DIR) install
endef

$(eval $(host-generic-package))
