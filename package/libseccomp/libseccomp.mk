################################################################################
#
# libseccomp
#
################################################################################

LIBSECCOMP_VERSION = v2.2.0
LIBSECCOMP_SITE = $(call github,seccomp,libseccomp,$(LIBSECCOMP_VERSION))
LIBSECCOMP_LICENSE = LGPLv2.1
LIBSECCOMP_LICENSE_FILES = LICENSE
LIBSECCOMP_INSTALL_STAGING = YES
LIBSECCOMP_AUTORECONF = YES

# Needed for autoreconf to work properly, see ./autogen.sh
define LIBSECCOMP_FIXUP_M4_DIR
	mkdir $(@D)/m4
endef
LIBSECCOMP_POST_EXTRACT_HOOKS += LIBSECCOMP_FIXUP_M4_DIR

$(eval $(autotools-package))
