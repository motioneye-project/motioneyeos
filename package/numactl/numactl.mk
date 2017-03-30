################################################################################
#
# numactl
#
################################################################################

NUMACTL_VERSION = 2.0.11
NUMACTL_SITE = ftp://oss.sgi.com/www/projects/libnuma/download
NUMACTL_PATCH = \
	https://github.com/numactl/numactl/commit/3770bdc4fa7b9059db5cd2aa8bb09b50fa15e456.patch \
	https://github.com/numactl/numactl/commit/31dc2951c758698bff060aeae8ffd8854616183b.patch
NUMACTL_LICENSE = LGPL-2.1 (libnuma), GPL-2.0 (programs)
NUMACTL_LICENSE_FILES = README
NUMACTL_INSTALL_STAGING = YES

$(eval $(autotools-package))
