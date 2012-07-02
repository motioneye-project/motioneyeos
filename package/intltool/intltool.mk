#############################################################
#
# intltool
#
#############################################################

INTLTOOL_VERSION = 0.40.6
INTLTOOL_SOURCE = intltool-$(INTLTOOL_VERSION).tar.bz2
INTLTOOL_SITE = http://ftp.acc.umu.se/pub/GNOME/sources/intltool/0.40/

HOST_INTLTOOL_DEPENDENCIES = host-libxml-parser-perl
HOST_INTLTOOL_CONF_OPT = \
  PERLLIB=$(HOST_DIR)/usr/lib/perl

$(eval $(autotools-package))
$(eval $(host-autotools-package))

