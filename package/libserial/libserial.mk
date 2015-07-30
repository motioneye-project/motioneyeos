################################################################################
#
# libserial
#
################################################################################

LIBSERIAL_VERSION = 0.6.0rc2
LIBSERIAL_SITE = http://downloads.sourceforge.net/libserial
LIBSERIAL_INSTALL_STAGING = YES
LIBSERIAL_LICENSE = GPLv2+
LIBSERIAL_LICENSE_FILES = COPYING
LIBSERIAL_DEPENDENCIES = boost

LIBSERIAL_CONF_ENV = ac_cv_prog_DOCBOOK2PDF=no

$(eval $(autotools-package))
