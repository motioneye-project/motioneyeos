#############################################################
#
# libeXosip2
#
#############################################################
LIBEXOSIP2_VERSION = 3.3.0
LIBEXOSIP2_SOURCE = libexosip2_$(LIBEXOSIP2_VERSION).orig.tar.gz
LIBEXOSIP2_PATCH = libexosip2_$(LIBEXOSIP2_VERSION)-1.diff.gz
LIBEXOSIP2_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/libe/libexosip2
LIBEXOSIP2_INSTALL_STAGING = YES

LIBEXOSIP2_DEPENDENCIES = host-pkg-config libosip2

ifneq ($(LIBEXOSIP2_PATCH),)
define LIBEXOSIP2_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		(cd $(@D)/debian/patches && for i in *; \
		 do $(SED) 's,^\+\+\+ .*cvs-$(LIBEXOSIP2_VERSION)/,+++ cvs-$(LIBEXOSIP2_VERSION)/,' $$i; \
		 done; \
		); \
		toolchain/patch-kernel.sh $(@D) $(@D)/debian/patches \*; \
	fi
endef
endif

LIBEXOSIP2_POST_PATCH_HOOKS += LIBEXOSIP2_DEBIAN_PATCHES

$(eval $(call AUTOTARGETS,package,libeXosip2))
