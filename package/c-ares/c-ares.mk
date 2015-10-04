################################################################################
#
# c-ares
#
################################################################################

C_ARES_VERSION = 1.10.0
C_ARES_SITE = http://c-ares.haxx.se/download
C_ARES_INSTALL_STAGING = YES
# Rebuild configure to avoid XC_CHECK_USER_CFLAGS
C_ARES_AUTORECONF = YES
C_ARES_LICENSE = MIT
# No standalone, use some source file
C_ARES_LICENSE_FILES = ares_mkquery.c

$(eval $(autotools-package))
