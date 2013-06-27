################################################################################
#
# tinymembench
#
################################################################################

TINYMEMBENCH_VERSION = v0.2
TINYMEMBENCH_SITE = http://github.com/ssvb/tinymembench/tarball/$(TINYMEMBENCH_VERSION)
TINYMEMBENCH_LICENSE = MIT
TINYMEMBENCH_LICENSE_FILES = main.c

define TINYMEMBENCH_BUILD_CMDS
	$(TARGET_CONFIGURE_OPTS) $(MAKE) -C $(@D)
endef

define TINYMEMBENCH_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/tinymembench \
		$(TARGET_DIR)/usr/bin/tinymembench
endef

$(eval $(generic-package))

