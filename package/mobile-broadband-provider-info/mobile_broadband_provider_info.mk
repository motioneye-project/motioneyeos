#############################################################
#
# mobile broadband provider info
#
#############################################################
MOBILE_BROADBAND_PROVIDER_INFO_VERSION = 20110511
MOBILE_BROADBAND_PROVIDER_INFO_SITE = http://ftp.gnome.org/pub/GNOME/sources/mobile-broadband-provider-info/$(MOBILE_BROADBAND_PROVIDER_INFO_VERSION)
MOBILE_BROADBAND_PROVIDER_INFO_INSTALL_STAGING = YES
MOBILE_BROADBAND_PROVIDER_INFO_DEPENDENCIES = host-pkg-config

$(eval $(autotools-package))
