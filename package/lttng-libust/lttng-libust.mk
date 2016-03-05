################################################################################
#
# lttng-libust
#
################################################################################

LTTNG_LIBUST_SITE = http://lttng.org/files/lttng-ust
LTTNG_LIBUST_VERSION = 2.7.1
LTTNG_LIBUST_SOURCE = lttng-ust-$(LTTNG_LIBUST_VERSION).tar.bz2
LTTNG_LIBUST_LICENSE = LGPLv2.1, MIT (system headers), GPLv2 (liblttng-ust-ctl/ustctl.c used by lttng-sessiond)
LTTNG_LIBUST_LICENSE_FILES = COPYING

LTTNG_LIBUST_INSTALL_STAGING = YES
LTTNG_LIBUST_DEPENDENCIES = liburcu util-linux

ifeq ($(BR2_PACKAGE_PYTHON),y)
LTTNG_LIBUST_DEPENDENCIES += python
else ifeq ($(BR2_PACKAGE_PYTHON3),y)
LTTNG_LIBUST_DEPENDENCIES += python3
else
LTTNG_LIBUST_CONF_ENV = am_cv_pathless_PYTHON="none"
endif

$(eval $(autotools-package))
