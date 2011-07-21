#############################################################
#
# libmnl
#
#############################################################

LIBMNL_VERSION = 1.0.1
LIBMNL_SOURCE = libmnl-$(LIBMNL_VERSION).tar.bz2
LIBMNL_SITE = http://netfilter.org/projects/libmnl/files
LIBMNL_INSTALL_STAGING = YES

$(eval $(call AUTOTARGETS,package,libmnl))
