#############################################################
#
# xinetd
#
#############################################################
XINETD_VERSION = 2.3.15
XINETD_SOURCE  = xinetd-$(XINETD_VERSION).tar.gz
XINETD_SITE    = http://www.xinetd.org

$(eval $(call AUTOTARGETS))
