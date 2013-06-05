################################################################################
#
# htop
#
################################################################################

HTOP_VERSION = 1.0.2
HTOP_SITE = http://downloads.sourceforge.net/project/htop/htop/$(HTOP_VERSION)
HTOP_DEPENDENCIES = ncurses
HTOP_AUTORECONF = YES
HTOP_CONF_OPT = --disable-unicode
HTOP_CONF_ENV = ac_cv_file__proc_stat=yes ac_cv_file__proc_meminfo=yes
HTOP_LICENSE = GPLv2
HTOP_LICENSE_FILES = COPYING

$(eval $(autotools-package))
