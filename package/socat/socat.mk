#############################################################
#
# socat
#
#############################################################

SOCAT_VERSION = 2.0.0-b2
SOCAT_SOURCE = socat-$(SOCAT_VERSION).tar.bz2
SOCAT_SITE = http://www.dest-unreach.org/socat/download/
SOCAT_CONF_ENV = sc_cv_termios_ispeed=no \
		 sc_cv_sys_crdly_shift=9 \
		 sc_cv_sys_tabdly_shift=11 \
		 sc_cv_sys_csize_shift=4

$(eval $(call AUTOTARGETS,package,socat))
