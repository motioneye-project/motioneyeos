################################################################################
#
# mksh
#
################################################################################

MKSH_VERSION = 57
MKSH_SOURCE = mksh-R$(MKSH_VERSION).tgz
MKSH_SITE = https://www.mirbsd.org/MirOS/dist/mir/mksh
# For MirOS License see https://www.mirbsd.org/TaC-mksh.txt
MKSH_LICENSE = MirOS, ISC
MKSH_LICENSE_FILES = mksh.1

define MKSH_BUILD_CMDS
	cd $(@D) && $(TARGET_MAKE_ENV) \
		TARGET_OS=Linux $(TARGET_CONFIGURE_OPTS) \
		sh ./Build.sh
endef

define MKSH_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/mksh $(TARGET_DIR)/bin/mksh
endef

# Add /bin/mksh to /etc/shells otherwise some login tools like dropbear
# can reject the user connection. See man shells.
define MKSH_ADD_MKSH_TO_SHELLS
	grep -qsE '^/bin/mksh$$' $(TARGET_DIR)/etc/shells \
		|| echo "/bin/mksh" >> $(TARGET_DIR)/etc/shells
endef
MKSH_TARGET_FINALIZE_HOOKS += MKSH_ADD_MKSH_TO_SHELLS

$(eval $(generic-package))
