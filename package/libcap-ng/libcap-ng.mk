#############################################################
#
# libcap-ng
#
#############################################################

LIBCAP_NG_VERSION = 0.6.6
LIBCAP_NG_SITE = http://people.redhat.com/sgrubb/libcap-ng/
LIBCAP_NG_SOURCE = libcap-ng-$(LIBCAP_NG_VERSION).tar.gz
LIBCAP_NG_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS))
