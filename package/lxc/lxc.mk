################################################################################
#
# lxc
#
################################################################################

LXC_VERSION = 1.1.5
LXC_SITE = https://linuxcontainers.org/downloads/lxc
LXC_LICENSE = LGPLv2.1+
LXC_LICENSE_FILES = COPYING
LXC_DEPENDENCIES = libcap host-pkgconf
# we're patching configure.ac
LXC_AUTORECONF = YES
LXC_CONF_OPTS = --disable-apparmor --with-distro=buildroot \
	--disable-lua --disable-python \
	$(if $(BR2_PACKAGE_BASH),,--disable-bash)

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
LXC_CONF_OPTS += --enable-seccomp
LXC_DEPENDENCIES += libseccomp
else
LXC_CONF_OPTS += --disable-seccomp
endif

$(eval $(autotools-package))
