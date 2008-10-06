#############################################################
#
# which
#
#############################################################
WHICH_VERSION:=2.20
WHICH_SOURCE:=which-$(WHICH_VERSION).tar.gz
WHICH_SITE:=http://www.xs4all.nl/~carlo17/which/
WHICH_AUTORECONF:=NO
WHICH_INSTALL_STAGING:=NO
WHICH_INSTALL_TARGET:=YES

WHICH_DEPENDENCIES:=uclibc

$(eval $(call AUTOTARGETS,package,which))

$(WHICH_HOOK_POST_INSTALL): $(WHICH_TARGET_INSTALL_TARGET)
	$(STRIPCMD) $(STRIP_STRIP_ALL) $(TARGET_DIR)/usr/bin/which
	touch $@
