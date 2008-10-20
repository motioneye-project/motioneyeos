#############################################################
#
# libdaemon (UNIX daemon library)
#
#############################################################

LIBDAEMON_VERSION:=0.13
LIBDAEMON_SOURCE:=libdaemon-$(LIBDAEMON_VERSION).tar.gz
LIBDAEMON_SITE:=http://0pointer.de/lennart/projects/libdaemon/
LIBDAEMON_AUTORECONF:=no
LIBDAEMON_INSTALL_STAGING:=YES
LIBDAEMON_INSTALL_TARGET:=YES
LIBDAEMON_CONF_ENV:=ac_cv_func_setpgrp_void=no
LIBDAEMON_CONF_OPT:=--disable-lynx $(DISABLE_NLS) $(DISABLE_LARGEFILE)

LIBDAEMON_DEPENDENCIES:=uclibc pkgconfig

$(eval $(call AUTOTARGETS,package,libdaemon))
