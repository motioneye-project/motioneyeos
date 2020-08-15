################################################################################
#
# f2fs-tools
#
################################################################################

F2FS_TOOLS_VERSION = 1.13.0
F2FS_TOOLS_SITE = https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git/snapshot
F2FS_TOOLS_CONF_ENV = ac_cv_file__git=no
F2FS_TOOLS_DEPENDENCIES = host-pkgconf util-linux
HOST_F2FS_TOOLS_DEPENDENCIES = host-pkgconf host-util-linux
# GIT version, shipped without configure
F2FS_TOOLS_AUTORECONF = YES
F2FS_TOOLS_INSTALL_STAGING = YES
F2FS_TOOLS_LICENSE = GPL-2.0
F2FS_TOOLS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
F2FS_TOOLS_CONF_OPTS += --with-selinux
F2FS_TOOLS_DEPENDENCIES += libselinux
else
F2FS_TOOLS_CONF_OPTS += --without-selinux
endif

ifeq ($(BR2_PACKAGE_UTIL_LINUX_LIBBLKID),y)
# util-linux is a dependency already, no need to list it again
F2FS_TOOLS_CONF_OPTS += --with-blkid
else
F2FS_TOOLS_CONF_OPTS += --without-blkid
endif

# blkid is only used to detect if we're overwriting a filesystem
# during mkfs, which only makes sense on the target, so we disable
# blkid support even if we have host-util-linux
HOST_F2FS_TOOLS_CONF_OPTS = \
	--without-selinux \
	--without-blkid

$(eval $(autotools-package))
$(eval $(host-autotools-package))
