################################################################################
#
# setserial
#
################################################################################

SETSERIAL_VERSION            = 2.17
SETSERIAL_PATCH              = setserial_2.17-45.3.diff.gz
SETSERIAL_SOURCE             = setserial_$(SETSERIAL_VERSION).orig.tar.gz
SETSERIAL_SITE               = http://snapshot.debian.org/archive/debian/20131001T214925Z/pool/main/s/setserial/

define SETSERIAL_APPLY_DEBIAN_PATCHES
	# Touching gorhack.h is needed for the Debian patch 18 to work
	if [ -d $(@D)/debian/patches ]; then \
		touch $(@D)/gorhack.h; \
		rm $(@D)/debian/patches/01_makefile.dpatch; \
		support/scripts/apply-patches.sh $(@D) $(@D)/debian/patches *.dpatch; \
	fi
endef

SETSERIAL_POST_PATCH_HOOKS += SETSERIAL_APPLY_DEBIAN_PATCHES

$(eval $(autotools-package))
