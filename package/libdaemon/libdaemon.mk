################################################################################
#
# libdaemon
#
################################################################################

LIBDAEMON_VERSION = 0.14
LIBDAEMON_SITE = http://0pointer.de/lennart/projects/libdaemon
LIBDAEMON_LICENSE = LGPLv2.1+
LIBDAEMON_LICENSE_FILES = LICENSE
LIBDAEMON_INSTALL_STAGING = YES
LIBDAEMON_CONF_ENV = ac_cv_func_setpgrp_void=no
LIBDAEMON_CONF_OPT = --disable-lynx
LIBDAEMON_DEPENDENCIES = host-pkgconf

$(eval $(autotools-package))
