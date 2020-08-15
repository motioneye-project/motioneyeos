################################################################################
#
# ncmpc
#
################################################################################

NCMPC_VERSION_MAJOR = 0
NCMPC_VERSION = $(NCMPC_VERSION_MAJOR).37
NCMPC_SOURCE = ncmpc-$(NCMPC_VERSION).tar.xz
NCMPC_SITE = http://www.musicpd.org/download/ncmpc/$(NCMPC_VERSION_MAJOR)
NCMPC_DEPENDENCIES = \
	boost \
	host-pkgconf \
	libmpdclient \
	ncurses \
	$(TARGET_NLS_DEPENDENCIES)
NCMPC_LICENSE = GPL-2.0+
NCMPC_LICENSE_FILES = COPYING

NCMPC_CONF_OPTS = \
	-Dcurses=ncurses \
	-Ddocumentation=disabled \
	$(if $(BR2_SYSTEM_ENABLE_NLS),-Dnls=enabled,-Dnls=disabled)

ifeq ($(BR2_PACKAGE_LIRC_TOOLS),y)
NCMPC_DEPENDENCIES += lirc-tools
NCMPC_CONF_OPTS += -Dlirc=enabled
else
NCMPC_CONF_OPTS += -Dlirc=disabled
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
NCMPC_DEPENDENCIES += pcre
NCMPC_CONF_OPTS += -Dregex=enabled
else
NCMPC_CONF_OPTS += -Dregex=disabled
endif

$(eval $(meson-package))
