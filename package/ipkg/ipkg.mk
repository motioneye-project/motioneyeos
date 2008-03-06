#############################################################
#
# ipkg
#
#############################################################

IPKG_VERSION = 0.99.163
IPKG_SOURCE = ipkg-$(IPKG_VERSION).tar.gz
IPKG_SITE = ftp://ftp.handhelds.org/packages/ipkg
IPKG_AUTORECONF = NO
IPKG_INSTALL_STAGING = YES
IPKG_INSTALL_TARGET = YES

IPKG_CONF_OPT = --target=$(GNU_TARGET_NAME) --host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) --prefix=/usr --sysconfdir=/etc 

IPKG_DEPENDENCIES = uclibc 

$(eval $(call AUTOTARGETS,package,ipkg))