################################################################################
#
# tar
#
################################################################################

TAR_VERSION = 1.32
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

# host-tar is used to create the archives in the VCS download backends and tar
# 1.30 and forward have changed the archive format. So archives generated with
# earlier versions are not bit-for-bit reproducible and the hashes would not
# match. Hence host-tar must be kept at version 1.29.
HOST_TAR_VERSION = 1.29
# host-tar: use cpio.gz instead of tar.gz to prevent chicken-egg problem
# of needing tar to build tar.
HOST_TAR_SOURCE = tar-$(HOST_TAR_VERSION).cpio.gz
define HOST_TAR_EXTRACT_CMDS
	mkdir -p $(@D)
	cd $(@D) && \
		$(call suitable-extractor,$(HOST_TAR_SOURCE)) $(TAR_DL_DIR)/$(HOST_TAR_SOURCE) | cpio -i --preserve-modification-time
	mv $(@D)/tar-$(HOST_TAR_VERSION)/* $(@D)
	rmdir $(@D)/tar-$(HOST_TAR_VERSION)
endef

HOST_TAR_CONF_OPTS = --without-selinux

# we are built before ccache
HOST_TAR_CONF_ENV = \
	CC="$(HOSTCC_NOCCACHE)" \
	CXX="$(HOSTCXX_NOCCACHE)"

$(eval $(host-autotools-package))
