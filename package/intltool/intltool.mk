################################################################################
#
# intltool
#
################################################################################

INTLTOOL_VERSION = 0.50.2
INTLTOOL_SITE = https://launchpad.net/intltool/trunk/$(INTLTOOL_VERSION)/+download
INTLTOOL_LICENSE = GPLv2+
INTLTOOL_LICENSE_FILES = COPYING

HOST_INTLTOOL_DEPENDENCIES = host-gettext host-libxml-parser-perl
HOST_INTLTOOL_CONF_OPTS = \
	PERL=`which perl` \
	PERL5LIB=$(HOST_DIR)/usr/lib/perl

$(eval $(autotools-package))
$(eval $(host-autotools-package))
