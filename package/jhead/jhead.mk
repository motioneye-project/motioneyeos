################################################################################
#
# jhead
#
################################################################################

JHEAD_VERSION = 3.04
JHEAD_SITE = http://www.sentex.net/~mwandel/jhead
JHEAD_LICENSE = Public Domain
JHEAD_LICENSE_FILES = readme.txt

define JHEAD_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define JHEAD_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/jhead $(TARGET_DIR)/usr/bin/jhead
endef

$(eval $(generic-package))
