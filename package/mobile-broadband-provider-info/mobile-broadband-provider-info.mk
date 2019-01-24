################################################################################
#
# mobile-broadband-provider-info
#
################################################################################

MOBILE_BROADBAND_PROVIDER_INFO_VERSION = 20190116
MOBILE_BROADBAND_PROVIDER_INFO_SITE = http://ftp.gnome.org/pub/GNOME/sources/mobile-broadband-provider-info/$(MOBILE_BROADBAND_PROVIDER_INFO_VERSION)
MOBILE_BROADBAND_PROVIDER_INFO_SOURCE = mobile-broadband-provider-info-$(MOBILE_BROADBAND_PROVIDER_INFO_VERSION).tar.xz
MOBILE_BROADBAND_PROVIDER_INFO_LICENSE = Public domain
MOBILE_BROADBAND_PROVIDER_INFO_LICENSE_FILES = COPYING
MOBILE_BROADBAND_PROVIDER_INFO_INSTALL_STAGING = YES
MOBILE_BROADBAND_PROVIDER_INFO_DEPENDENCIES = host-pkgconf

$(eval $(autotools-package))
