################################################################################
#
# sysdig
#
################################################################################

SYSDIG_VERSION = 0.23.1
SYSDIG_SITE = $(call github,draios,sysdig,$(SYSDIG_VERSION))
SYSDIG_LICENSE = GPL-2.0
SYSDIG_LICENSE_FILES = COPYING
SYSDIG_CONF_OPTS = -DUSE_BUNDLED_LUAJIT=OFF -DUSE_BUNDLED_ZLIB=OFF \
	-DUSE_BUNDLED_JSONCPP=OFF -DENABLE_DKMS=OFF -DUSE_BUNDLED_CURL=OFF \
	-DUSE_BUNDLED_NCURSES=OFF -DUSE_BUNDLED_OPENSSL=OFF \
	-DUSE_BUNDLED_JQ=OFF -DUSE_BUNDLED_B64=OFF
SYSDIG_DEPENDENCIES = zlib luajit jsoncpp libcurl ncurses openssl jq libb64 elfutils
SYSDIG_SUPPORTS_IN_SOURCE_BUILD = NO

# sysdig creates the module Makefile from a template, which contains a
# single place-holder, KBUILD_FLAGS, wich is only replaced with two
# things:
#   - debug flags, which we don't care about here,
#   - 'sysdig-feature' flags, which are never set, so always empty
# So, just replace the place-holder with the only meaningful value: nothing.
define SYSDIG_MODULE_GEN_MAKEFILE
	$(INSTALL) -m 0644 $(@D)/driver/Makefile.in $(@D)/driver/Makefile
	$(SED) 's/@KBUILD_FLAGS@//;' $(@D)/driver/Makefile
	$(SED) 's/@PROBE_NAME@/sysdig-probe/;' $(@D)/driver/Makefile
endef
SYSDIG_POST_PATCH_HOOKS += SYSDIG_MODULE_GEN_MAKEFILE

# Don't build the driver as part of the 'standard' procedure, we'll
# build it on our own with the kernel-module infra.
SYSDIG_CONF_OPTS += -DBUILD_DRIVER=OFF

SYSDIG_MODULE_SUBDIRS = driver
SYSDIG_MODULE_MAKE_OPTS = KERNELDIR=$(LINUX_DIR)

$(eval $(kernel-module))
$(eval $(cmake-package))
