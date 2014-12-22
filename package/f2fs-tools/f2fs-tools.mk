################################################################################
#
# f2fs-tools
#
################################################################################

F2FS_TOOLS_VERSION = baac4b4e6f41ceb02511da49dd3707674f3fea21
F2FS_TOOLS_SITE = http://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git
F2FS_TOOLS_SITE_METHOD = git
F2FS_TOOLS_CONF_ENV = ac_cv_file__git=no
F2FS_TOOLS_DEPENDENCIES = host-pkgconf util-linux
# GIT version, shipped without configure
F2FS_TOOLS_AUTORECONF = YES
F2FS_TOOLS_INSTALL_STAGING = YES
F2FS_TOOLS_LICENSE = GPLv2
F2FS_TOOLS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
