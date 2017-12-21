################################################################################
#
# openpgm
#
################################################################################

OPENPGM_VERSION = release-5-2-122
OPENPGM_SITE = $(call github,steve-o,openpgm,$(OPENPGM_VERSION))
OPENPGM_LICENSE = LGPL-2.1+
OPENPGM_LICENSE_FILES = openpgm/pgm/LICENSE
OPENPGM_INSTALL_STAGING = YES
OPENPGM_SUBDIR = openpgm/pgm
OPENPGM_AUTORECONF = YES

# We need to create the m4 directory to make sure that autoreconf will
# start calling libtoolize. Otherwise it will start with aclocal and it
# will fail because the m4 directory doesn't exist.
define OPENPGM_CREATE_M4_DIR
	mkdir -p $(@D)/$(OPENPGM_SUBDIR)/m4
endef
OPENPGM_POST_PATCH_HOOKS += OPENPGM_CREATE_M4_DIR

OPENPGM_CONF_ENV = \
	ac_cv_file__proc_cpuinfo=yes \
	ac_cv_file__dev_rtc=no \
	ac_cv_file__dev_hpet=no

$(eval $(autotools-package))
