################################################################################
#
# lxc
#
################################################################################

LXC_VERSION = 2.0.8
LXC_SITE = https://linuxcontainers.org/downloads/lxc
LXC_LICENSE = LGPL-2.1+
LXC_LICENSE_FILES = COPYING
LXC_DEPENDENCIES = host-pkgconf
LXC_INSTALL_STAGING = YES

LXC_CONF_OPTS = --disable-apparmor --with-distro=buildroot \
	--disable-python --disable-werror \
	$(if $(BR2_PACKAGE_BASH),,--disable-bash)

ifeq ($(BR2_PACKAGE_GNUTLS),y)
LXC_CONF_OPTS += --enable-gnutls
LXC_DEPENDENCIES += gnutls
else
LXC_CONF_OPTS += --disable-gnutls
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
LXC_CONF_OPTS += --enable-capabilities
LXC_DEPENDENCIES += libcap
else
LXC_CONF_OPTS += --disable-capabilities
endif

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
LXC_CONF_OPTS += --enable-seccomp
LXC_DEPENDENCIES += libseccomp
else
LXC_CONF_OPTS += --disable-seccomp
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
LXC_CONF_OPTS += --enable-selinux
LXC_DEPENDENCIES += libselinux
else
LXC_CONF_OPTS += --disable-selinux
endif

ifeq ($(BR2_PACKAGE_HAS_LUAINTERPRETER),y)
LXC_CONF_OPTS += --enable-lua
LXC_DEPENDENCIES += luainterpreter
ifeq ($(BR2_PACKAGE_LUAJIT),y)
# By default, lxc will only search for lua.pc
LXC_CONF_OPTS += --with-lua-pc=luajit
endif
else
LXC_CONF_OPTS += --disable-lua
endif

$(eval $(autotools-package))
