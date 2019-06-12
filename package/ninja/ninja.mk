################################################################################
#
# ninja
#
################################################################################

NINJA_VERSION = 1.9.0
NINJA_SITE = $(call github,ninja-build,ninja,v$(NINJA_VERSION))
NINJA_LICENSE = Apache-2.0
NINJA_LICENSE_FILES = COPYING

# Although Ninja supports both Python2 and Python3, we enforce Python3
# on the host for the following reason: Meson is the only package
# using Ninja so far and Meson requires Python3. In this way, we
# prevent both Python2 and Python3 from being created on the host,
# which is time consuming and without benefit.
HOST_NINJA_DEPENDENCIES = host-python3

define HOST_NINJA_BUILD_CMDS
	(cd $(@D); ./configure.py --bootstrap)
endef

define HOST_NINJA_INSTALL_CMDS
	$(INSTALL) -m 0755 -D $(@D)/ninja $(HOST_DIR)/bin/ninja
endef

$(eval $(host-generic-package))
