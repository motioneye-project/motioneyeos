################################################################################
#
# yajl
#
################################################################################

YAJL_VERSION = 2.0.2
YAJL_SITE = git://github.com/lloyd/yajl.git
YAJL_INSTALL_STAGING = YES

$(eval $(call CMAKETARGETS,package,yajl))
