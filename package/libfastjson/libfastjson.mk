################################################################################
#
# libfastjson
#
################################################################################

LIBFASTJSON_VERSION = 0.99.8
LIBFASTJSON_SITE = $(call github,rsyslog,libfastjson,v$(LIBFASTJSON_VERSION))
LIBFASTJSON_INSTALL_STAGING = YES
LIBFASTJSON_CONF_ENV = ac_cv_prog_cc_c99='-std=gnu99'
# From git
LIBFASTJSON_AUTORECONF = YES
LIBFASTJSON_LICENSE = MIT
LIBFASTJSON_LICENSE_FILES = COPYING

$(eval $(autotools-package))
