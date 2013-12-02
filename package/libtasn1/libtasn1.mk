################################################################################
#
# libtasn1
#
################################################################################

LIBTASN1_VERSION = 3.4
LIBTASN1_SITE = http://ftp.gnu.org/gnu/libtasn1
LIBTASN1_DEPENDENCIES = host-bison
LIBTASN1_LICENSE = GPLv3+ LGPLv2.1+
LIBTASN1_LICENSE_FILES = COPYING COPYING.LIB
LIBTASN1_INSTALL_STAGING = YES
# 'missing' fallback logic botched so disable it completely
LIBTASN1_CONF_ENV = MAKEINFO="true"

$(eval $(autotools-package))
