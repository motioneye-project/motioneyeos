#############################################################
#
# xinetd
#
#############################################################
XINETD_VERSION       = 2.3.15
XINETD_SOURCE        = xinetd-$(XINETD_VERSION).tar.gz
XINETD_SITE          = http://www.xinetd.org
XINETD_LICENSE       = xinetd license
XINETD_LICENSE_FILES = COPYRIGHT

ifneq ($(BR2_INET_RPC),y)
XINETD_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -DNO_RPC"
endif

XINETD_MAKE_OPT = AR="$(TARGET_AR)"

$(eval $(autotools-package))
