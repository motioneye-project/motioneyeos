################################################################################
#
# libnfc-llcp
#
################################################################################

LIBNFC_LLCP_VERSION = 1103
LIBNFC_LLCP_SITE = http://nfc-tools.googlecode.com/svn/trunk/libnfc-llcp/
LIBNFC_LLCP_SITE_METHOD = svn
LIBNFC_LLCP_DEPENDENCIES = libnfc
LIBNFC_LLCP_AUTORECONF = YES
LIBNFC_LLCP_AUTORECONF_OPT = --install --force --verbose
LIBNFC_LLCP_INSTALL_STAGING = YES

$(eval $(autotools-package))
