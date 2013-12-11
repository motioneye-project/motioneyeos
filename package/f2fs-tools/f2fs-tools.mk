################################################################################
#
# f2fs-tools
#
################################################################################

F2FS_TOOLS_VERSION = 576cb469e73b9342f1d10ba5d0428bbce22cbc3b
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
