#############################################################
#
# PCRE
#
#############################################################

PCRE_VERSION = 8.32
PCRE_SITE = ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre
PCRE_LICENSE = BSD-3c
PCRE_LICENSE_FILES = LICENCE
PCRE_INSTALL_STAGING = YES
PCRE_CONFIG_SCRIPTS = pcre-config

ifneq ($(BR2_INSTALL_LIBSTDCPP),y)
# pcre will use the host g++ if a cross version isn't available
PCRE_CONF_OPT = --disable-cpp
endif

$(eval $(autotools-package))
