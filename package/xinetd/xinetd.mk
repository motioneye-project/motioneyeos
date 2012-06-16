#############################################################
#
# xinetd
#
#############################################################
XINETD_VERSION = 2.3.15
XINETD_SOURCE  = xinetd-$(XINETD_VERSION).tar.gz
XINETD_SITE    = http://www.xinetd.org

ifneq ($(BR2_INET_RPC),y)
XINETD_CONF_ENV = CFLAGS="$(TARGET_CFLAGS) -DNO_RPC"
endif

$(eval $(call AUTOTARGETS))
