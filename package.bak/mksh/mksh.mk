################################################################################
#
# mksh
#
################################################################################

MKSH_VERSION = R54
MKSH_SOURCE = mksh-$(MKSH_VERSION).tgz
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

$(eval $(generic-package))
