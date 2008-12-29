#############################################################
#
# gmpc
#
#############################################################
GMPC_VERSION = 0.17.0
GMPC_SOURCE = gmpc-$(GMPC_VERSION).tar.gz
GMPC_SITE = http://download.sarine.nl/download/Programs/gmpc/$(GMPC_VERSION)/
GMPC_LIBTOOL_PATCH = NO
GMPC_CONF_ENV = ac_cv_lib_curl_curl_global_init=yes
GMPC_CONF_OPT = --disable-mmkeys $(DISABLE_NLS)


GMPC_DEPENDENCIES = libglib2 libgtk2 libglade libcurl libmpd


$(eval $(call AUTOTARGETS,package,gmpc))
