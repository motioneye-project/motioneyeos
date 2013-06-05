################################################################################
#
# argus
#
################################################################################

ARGUS_VERSION = 3.0.0.rc.34
ARGUS_SOURCE = argus_$(ARGUS_VERSION).orig.tar.gz
ARGUS_PATCH = argus_$(ARGUS_VERSION)-1.diff.gz
ARGUS_SITE = $(BR2_DEBIAN_MIRROR)/debian/pool/main/a/argus/
ARGUS_DEPENDENCIES = libpcap
ARGUS_LICENSE = GPLv2+
ARGUS_LICENSE_FILES = COPYING

define ARGUS_DEBIAN_PATCH_APPLY
	if [ -d $(@D)/debian/patches ]; then \
		support/scripts/apply-patches.sh $(@D) $(@D)/debian/patches \*.patch; \
	fi
endef

ARGUS_POST_PATCH_HOOKS += ARGUS_DEBIAN_PATCH_APPLY

$(eval $(autotools-package))
