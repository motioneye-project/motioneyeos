#############################################################
#
# mobile broadband provider info
#
#############################################################
MOBILE_BROADBAND_PROVIDER_INFO_VERSION = 20110511
MOBILE_BROADBAND_PROVIDER_INFO_SITE = git://git.gnome.org/mobile-broadband-provider-info
MOBILE_BROADBAND_PROVIDER_INFO_INSTALL_STAGING = YES
MOBILE_BROADBAND_PROVIDER_INFO_DEPENDENCIES = host-pkg-config

MOBILE_BROADBAND_PROVIDER_INFO_AUTORECONF = YES

$(eval $(call AUTOTARGETS))
