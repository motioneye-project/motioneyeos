################################################################################
#
# libserial
#
################################################################################

LIBSERIAL_VERSION = 1.0.0
LIBSERIAL_SITE = $(call github,crayzeewulf,libserial,v$(LIBSERIAL_VERSION))
LIBSERIAL_INSTALL_STAGING = YES
LIBSERIAL_LICENSE = BSD-3-Clause
LIBSERIAL_LICENSE_FILES = LICENSE.txt
LIBSERIAL_DEPENDENCIES = boost
# From git
LIBSERIAL_AUTORECONF = YES

LIBSERIAL_CONF_ENV = ac_cv_prog_DOCBOOK2PDF=no
LIBSERIAL_CONF_OPTS = \
	--disable-tests \
	--without-python

$(eval $(autotools-package))
