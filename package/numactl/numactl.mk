################################################################################
#
# numactl
#
################################################################################

NUMACTL_VERSION = 2.0.10
NUMACTL_SITE = ftp://oss.sgi.com/www/projects/libnuma/download
NUMACTL_LICENSE = LGPLv2.1 (libnuma), GPLv2 (programs)
NUMACTL_LICENSE_FILES = README
NUMACTL_INSTALL_STAGING = YES

# numactl tarball doesn't contain a pregenerated configure script.
NUMACTL_AUTORECONF = YES

$(eval $(autotools-package))
