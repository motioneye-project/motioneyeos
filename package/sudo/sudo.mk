#############################################################
#
# sudo
#
#############################################################

SUDO_VERSION = 1.8.5p1
SUDO_SITE    = http://www.sudo.ws/sudo/dist
SUDO_CONF_OPT = \
		--without-lecture \
		--without-sendmail \
		--without-umask \
		--with-logging=syslog \
		--without-interfaces \
		--without-pam

define SUDO_PERMISSIONS
/usr/bin/sudo			 f 4755	0 0 - - - - -
endef

$(eval $(autotools-package))
