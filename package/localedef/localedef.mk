################################################################################
#
# localedef
#
################################################################################

LOCALEDEF_VERSION = 2.14.1-r17443-ptx1
LOCALEDEF_SOURCE = localedef-eglibc-$(LOCALEDEF_VERSION).tar.bz2
LOCALEDEF_SITE = http://www.pengutronix.de/software/ptxdist/temporary-src

HOST_LOCALEDEF_CONF_OPTS += \
	--prefix=/usr \
	--with-glibc=./eglibc

# The makefile does not implement an install target
define HOST_LOCALEDEF_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/localedef $(HOST_DIR)/usr/bin/localedef
endef

$(eval $(host-autotools-package))
