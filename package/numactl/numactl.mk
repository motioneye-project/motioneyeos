################################################################################
#
# numactl
#
################################################################################

NUMACTL_VERSION = v2.0.12
NUMACTL_SITE = $(call github,numactl,numactl,$(NUMACTL_VERSION))
NUMACTL_LICENSE = LGPL-2.1 (libnuma), GPL-2.0 (programs)
NUMACTL_LICENSE_FILES = README.md
NUMACTL_INSTALL_STAGING = YES
NUMACTL_AUTORECONF = YES

$(eval $(autotools-package))
