################################################################################
#
# lrzsz
#
################################################################################

LRZSZ_VERSION = 0.12.20
LRZSZ_SITE = http://www.ohse.de/uwe/releases

LRZSR_CONF_OPT = --disable-timesync

define LRZSZ_POST_CONFIGURE_HOOKS
	$(SED) "s/-lnsl//;" $(@D)/src/Makefile
	$(SED) "s~\(#define ENABLE_SYSLOG.*\)~/* \1 */~;" $(@D)/config.h
endef

define LRZSZ_BUILD_HOOKS
	$(MAKE) CROSS_COMPILE="$(TARGET_CROSS)" prefix="$(TARGET_DIR)" -C $(@D)
endef

define LRZSZ_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/src/lrz $(TARGET_DIR)/usr/bin/rz
	$(INSTALL) -m 0755 -D $(@D)/src/lsz $(TARGET_DIR)/usr/bin/sz
	ln -sf rz $(TARGET_DIR)/usr/bin/lrz
	ln -sf sz $(TARGET_DIR)/usr/bin/lsz
endef

define LRZSZ_CLEAN_CMDS
	rm -f $(addprefix $(TARGET_DIR)/usr/bin/,rz sz lrz lsz)
	-$(MAKE) -C $(@D) clean
endef

$(eval $(autotools-package))
