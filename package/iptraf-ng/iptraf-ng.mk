################################################################################
#
# iptraf-ng
#
################################################################################

IPTRAF_NG_VERSION = 1.1.4
IPTRAF_NG_SITE = https://fedorahosted.org/releases/i/p/iptraf-ng
IPTRAF_NG_LICENSE = GPLv2+
IPTRAF_NG_LICENSE_FILES = LICENSE
IPTRAF_NG_DEPENDENCIES = ncurses

IPTRAF_NG_MAKE_ENV = NCURSES_LDFLAGS="-lpanel -lncurses"

$(eval $(autotools-package))
