################################################################################
#
# dacapo
#
################################################################################

DACAPO_VERSION = 9.12-MR1-bach
DACAPO_SOURCE = dacapo-$(DACAPO_VERSION).jar
DACAPO_SITE = http://sourceforge.net/projects/dacapobench/files/9.12-bach-MR1
DACAPO_LICENSE = Apache-2.0
DACAPO_LICENSE_FILES = LICENSE

define DACAPO_EXTRACT_CMDS
	unzip $(DACAPO_DL_DIR)/$(DACAPO_SOURCE) LICENSE -d $(@D)
endef

define DACAPO_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 755 $(DACAPO_DL_DIR)/$(DACAPO_SOURCE) $(TARGET_DIR)/usr/bin/$(DACAPO_SOURCE)
endef

$(eval $(generic-package))
