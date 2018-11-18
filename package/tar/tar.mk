################################################################################
#
# tar
#
################################################################################

TAR_VERSION = 1.29
TAR_SOURCE = tar-$(TAR_VERSION).tar.xz
TAR_SITE = $(BR2_GNU_MIRROR)/tar
# busybox installs in /bin, so we need tar to install as well in /bin
# so that we don't end up with two different tar
TAR_CONF_OPTS = --exec-prefix=/
TAR_LICENSE = GPL-3.0+
TAR_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_ACL),y)
TAR_DEPENDENCIES += acl
TAR_CONF_OPTS += --with-posix-acls
else
TAR_CONF_OPTS += --without-posix-acls
endif

ifeq ($(BR2_PACKAGE_ATTR),y)
TAR_DEPENDENCIES += attr
TAR_CONF_OPTS += --with-xattrs
else
TAR_CONF_OPTS += --without-xattrs
endif

$(eval $(autotools-package))

# host-tar: use cpio.gz instead of tar.gz to prevent chicken-egg problem
# of needing tar to build tar.
HOST_TAR_SOURCE = tar-$(TAR_VERSION).cpio.gz
define HOST_TAR_EXTRACT_CMDS
	mkdir -p $(@D)
	cd $(@D) && \
		$(call suitable-extractor,$(HOST_TAR_SOURCE)) $(TAR_DL_DIR)/$(HOST_TAR_SOURCE) | cpio -i --preserve-modification-time
	mv $(@D)/tar-$(TAR_VERSION)/* $(@D)
	rmdir $(@D)/tar-$(TAR_VERSION)
endef

HOST_TAR_CONF_OPTS = --without-selinux

# we are built before ccache
HOST_TAR_CONF_ENV = \
	CC="$(HOSTCC_NOCCACHE)" \
	CXX="$(HOSTCXX_NOCCACHE)"

$(eval $(host-autotools-package))
