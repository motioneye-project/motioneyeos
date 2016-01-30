################################################################################
#
# numactl
#
################################################################################

NUMACTL_VERSION = 2.0.11
NUMACTL_SITE = ftp://oss.sgi.com/www/projects/libnuma/download
NUMACTL_LICENSE = LGPLv2.1 (libnuma), GPLv2 (programs)
NUMACTL_LICENSE_FILES = README
NUMACTL_INSTALL_STAGING = YES

$(eval $(autotools-package))
