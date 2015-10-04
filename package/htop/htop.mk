################################################################################
#
# htop
#
################################################################################

HTOP_VERSION = 1.0.3
HTOP_SITE = http://hisham.hm/htop/releases/$(HTOP_VERSION)
HTOP_DEPENDENCIES = ncurses
# For htop-01-native-affinity.patch
HTOP_AUTORECONF = YES
HTOP_CONF_OPTS = --disable-unicode
HTOP_CONF_ENV = ac_cv_file__proc_stat=yes ac_cv_file__proc_meminfo=yes
HTOP_LICENSE = GPLv2
HTOP_LICENSE_FILES = COPYING

$(eval $(autotools-package))
