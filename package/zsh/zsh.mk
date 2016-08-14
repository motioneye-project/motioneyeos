################################################################################
#
# zsh
#
################################################################################

ZSH_VERSION = 5.2
ZSH_SITE = http://www.zsh.org/pub
ZSH_SOURCE = zsh-$(ZSH_VERSION).tar.xz
ZSH_DEPENDENCIES = ncurses
ZSH_CONF_OPTS = --bindir=/bin
# Patching configure.ac
ZSH_AUTORECONF = YES
ZSH_LICENSE = MIT-like
ZSH_LICENSE_FILES = LICENCE

ifeq ($(BR2_PACKAGE_GDBM),y)
ZSH_CONF_OPTS += --enable-gdbm
ZSH_DEPENDENCIES += gdbm
else
ZSH_CONF_OPTS += --disable-gdbm
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
ZSH_CONF_OPTS += --enable-cap
ZSH_DEPENDENCIES += libcap
else
ZSH_CONF_OPTS += --disable-cap
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
ZSH_CONF_OPTS += --enable-pcre
ZSH_CONF_ENV += ac_cv_prog_PCRECONF=$(STAGING_DIR)/usr/bin/pcre-config
ZSH_DEPENDENCIES += pcre
else
ZSH_CONF_OPTS += --disable-pcre
endif

# Remove versioned zsh-x.y.z binary taking up space
define ZSH_TARGET_INSTALL_FIXUPS
	rm -f $(TARGET_DIR)/bin/zsh-$(ZSH_VERSION)
endef
ZSH_POST_INSTALL_TARGET_HOOKS += ZSH_TARGET_INSTALL_FIXUPS

$(eval $(autotools-package))
