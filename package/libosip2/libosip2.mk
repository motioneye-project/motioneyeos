#############################################################
#
# libosip2
#
#############################################################
LIBOSIP2_VERSION = 3.3.0
LIBOSIP2_SOURCE = libosip2_$(LIBOSIP2_VERSION).orig.tar.gz
LIBOSIP2_PATCH = libosip2_$(LIBOSIP2_VERSION)-1.diff.gz
LIBOSIP2_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/libo/libosip2
LIBOSIP2_INSTALL_STAGING = YES

ifneq ($(LIBOSIP2_PATCH),)
define LIBOSIP2_DEBIAN_PATCHES
	if [ -d $(@D)/debian/patches ]; then \
		(cd $(@D)/debian/patches && for i in *; \
		 do $(SED) 's,^\+\+\+ .*cvs-$(LIBOSIP2_VERSION)/,+++ cvs-$(LIBOSIP2_VERSION)/,' $$i; \
		 done; \
		); \
		toolchain/patch-kernel.sh $(@D) $(@D)/debian/patches \*; \
	fi
endef
endif

LIBOSIP2_POST_PATCH_HOOKS += LIBOSIP2_DEBIAN_PATCHES

$(eval $(call AUTOTARGETS,package,libosip2))
