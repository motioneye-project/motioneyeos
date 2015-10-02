################################################################################
#
# zsh
#
################################################################################

ZSH_VERSION = 5.1.1
ZSH_SITE = http://www.zsh.org/pub
ZSH_SOURCE = zsh-$(ZSH_VERSION).tar.xz
ZSH_DEPENDENCIES = ncurses
ZSH_CONF_OPTS = --bindir=/bin
ZSH_LICENSE = MIT-like
ZSH_LICENSE_FILES = LICENCE

# Remove versioned zsh-x.y.z binary taking up space
define ZSH_TARGET_INSTALL_FIXUPS
	rm -f $(TARGET_DIR)/bin/zsh-$(ZSH_VERSION)
endef
ZSH_POST_INSTALL_TARGET_HOOKS += ZSH_TARGET_INSTALL_FIXUPS

$(eval $(autotools-package))
