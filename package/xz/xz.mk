#############################################################
#
# xz-utils
#
#############################################################
XZ_VERSION = 5.0.0
XZ_SOURCE = xz-$(XZ_VERSION).tar.bz2
XZ_SITE = http://tukaani.org/xz/
XZ_INSTALL_STAGING = YES
XZ_LIBTOOL_PATCH = NO

$(eval $(call AUTOTARGETS,package,xz))
$(eval $(call AUTOTARGETS,package,xz,host))
