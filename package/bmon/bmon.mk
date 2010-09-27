#############################################################
#
# bmon
#
#############################################################

BMON_VERSION = 2.1.0
BMON_SOURCE = bmon-$(BMON_VERSION).tar.gz
BMON_SITE = http://distfiles.gentoo.org/distfiles
BMON_DEPENDENCIES = ncurses

define BMON_UNINSTALL_TARGET_CMDS
	rm -f $(TARGET_DIR)/usr/bin/bmon
endef

$(eval $(call AUTOTARGETS,package,bmon))
