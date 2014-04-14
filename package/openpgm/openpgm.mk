################################################################################
#
# openpgm
#
################################################################################

OPENPGM_VERSION = 5.1.118~dfsg
OPENPGM_SOURCE = libpgm-$(OPENPGM_VERSION).tar.gz
OPENPGM_SITE = http://openpgm.googlecode.com/files/
OPENPGM_LICENSE = LGPLv2.1+
OPENPGM_LICENSE_FILES = openpgm/pgm/LICENSE
OPENPGM_INSTALL_STAGING = YES
OPENPGM_AUTORECONF = YES
OPENPGM_SUBDIR = openpgm/pgm/
OPENPGM_DEPENDENCIES = $(if $(BR2_PACKAGE_PYTHON3),host-python3,host-python)
OPENPGM_CONF_ENV = ac_cv_file__proc_cpuinfo=yes ac_cv_file__dev_rtc=no \
                   ac_cv_file__dev_hpet=no

$(eval $(autotools-package))
