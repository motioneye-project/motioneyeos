################################################################################
#
# bubblewrap
#
################################################################################

BUBBLEWRAP_VERSION = 0.4.1
BUBBLEWRAP_SITE = https://github.com/containers/bubblewrap/releases/download/v$(BUBBLEWRAP_VERSION)
BUBBLEWRAP_SOURCE = bubblewrap-$(BUBBLEWRAP_VERSION).tar.xz
BUBBLEWRAP_DEPENDENCIES = host-pkgconf libcap

BUBBLEWRAP_LICENSE = LGPL-2.0+
BUBBLEWRAP_LICENSE_FILES = COPYING

BUBBLEWRAP_CONF_OPTS = \
	--enable-require-userns=no \
	--disable-man \
	--disable-sudo \
	--with-priv-mode=none

ifeq ($(BR2_PACKAGE_BASH_COMPLETION),y)
BUBBLEWRAP_CONF_OPTS += --with-bash-completion-dir=/usr/share/bash-completion/completions
else
BUBBLEWRAP_CONF_OPTS += --without-bash-completion-dir
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
BUBBLEWRAP_CONF_OPTS += --enable-selinux
BUBBLEWRAP_DEPENDENCIES += libselinux
else
BUBBLEWRAP_CONF_OPTS += --disable-selinux
endif

# We need to mark bwrap as setuid, in case the kernel
# has user namespaces disabled for non-root users.
define BUBBLEWRAP_PERMISSIONS
	/usr/bin/bwrap f 1755 0 0 - - - - -
endef

$(eval $(autotools-package))
