################################################################################
#
# ninja
#
################################################################################

NINJA_VERSION = v1.7.2
NINJA_SITE = $(call github,ninja-build,ninja,$(NINJA_VERSION))
NINJA_LICENSE = Apache-2.0
NINJA_LICENSE_FILES = COPYING

HOST_NINJA_DEPENDENCIES = $(if $(BR2_PACKAGE_PYTHON3),host-python3,host-python)

define HOST_NINJA_BUILD_CMDS
	(cd $(@D); ./configure.py --bootstrap)
endef

define HOST_NINJA_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/ninja $(HOST_DIR)/bin/ninja
endef

$(eval $(host-generic-package))
