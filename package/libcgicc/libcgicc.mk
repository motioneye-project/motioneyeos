################################################################################
#
# libcgicc
#
################################################################################

LIBCGICC_VERSION = 3.2.14
LIBCGICC_SITE = $(BR2_GNU_MIRROR)/cgicc
LIBCGICC_SOURCE = cgicc-$(LIBCGICC_VERSION).tar.gz
LIBCGICC_LICENSE = LGPLv3+ (library), GFDL1.2+ (docs)
LIBCGICC_LICENSE_FILES = COPYING.LIB COPYING.DOC
LIBCGICC_INSTALL_STAGING = YES
LIBCGICC_AUTORECONF = YES
LIBCGICC_CONFIG_SCRIPTS = cgicc-config
LIBCGICC_CONF_OPT = \
	--disable-demos \
	--disable-doc

$(eval $(autotools-package))
