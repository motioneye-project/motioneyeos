################################################################################
#
# w_scan
#
################################################################################

W_SCAN_VERSION = 20141122
W_SCAN_SOURCE = w_scan-$(W_SCAN_VERSION).tar.bz2
W_SCAN_SITE = http://wirbel.htpc-forum.de/w_scan
W_SCAN_LICENSE = GPL-2.0+
W_SCAN_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_LIBICONV),y)
W_SCAN_DEPENDENCIES += libiconv
W_SCAN_CONF_ENV += LIBS=-liconv
endif

$(eval $(autotools-package))
