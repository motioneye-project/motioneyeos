################################################################################
#
# intel-gmmlib
#
################################################################################

INTEL_GMMLIB_VERSION = 18.4.1
INTEL_GMMLIB_SITE = https://github.com/intel/gmmlib/archive
INTEL_GMMLIB_LICENSE = MIT
INTEL_GMMLIB_LICENSE_FILES = LICENSE.md

INTEL_GMMLIB_INSTALL_STAGING = YES
INTEL_GMMLIB_SUPPORTS_IN_SOURCE_BUILD = NO

INTEL_GMMLIB_CONF_OPTS = -DRUN_TEST_SUITE=OFF

$(eval $(cmake-package))
