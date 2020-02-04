################################################################################
#
# openpgm
#
################################################################################

OPENPGM_VERSION = 5-2-122
OPENPGM_SITE = $(call github,steve-o,openpgm,release-$(OPENPGM_VERSION))
OPENPGM_LICENSE = LGPL-2.1+
OPENPGM_LICENSE_FILES = openpgm/pgm/LICENSE
OPENPGM_INSTALL_STAGING = YES
OPENPGM_SUBDIR = openpgm/pgm
OPENPGM_AUTORECONF = YES

OPENPGM_CONF_ENV = \
	ac_cv_file__proc_cpuinfo=yes \
	ac_cv_file__dev_rtc=no \
	ac_cv_file__dev_hpet=no

$(eval $(autotools-package))
