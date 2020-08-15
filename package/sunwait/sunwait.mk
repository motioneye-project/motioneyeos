################################################################################
#
# sunwait
#
################################################################################

SUNWAIT_VERSION = 7326b53e5406c7ebd552ae6dc0fc659252a18e7f
SUNWAIT_SITE = $(call github,risacher,sunwait,$(SUNWAIT_VERSION))
SUNWAIT_LICENSE = GPL-3.0
SUNWAIT_LICENSE_FILES = LICENSE

SUNWAIT_MAKE_OPTS = \
	$(TARGET_CONFIGURE_OPTS) \
	C=$(TARGET_CXX) \
	CFLAGS="$(TARGET_CFLAGS) -c" \
	LDFLAGS="$(TARGET_LDFLAGS) -lm"

define SUNWAIT_BUILD_CMDS
	$(MAKE) $(SUNWAIT_MAKE_OPTS) -C $(@D) all
endef

define SUNWAIT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/sunwait $(TARGET_DIR)/usr/bin/sunwait
endef

$(eval $(generic-package))
