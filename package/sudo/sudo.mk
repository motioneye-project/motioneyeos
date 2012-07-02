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

$(eval $(autotools-package))
