#############################################################
#
# libcgi
#
#############################################################
LIBCGI_VERSION:=1.0
LIBCGI_SOURCE:=libcgi-$(LIBCGI_VERSION).tar.gz
LIBCGI_SITE:=http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libcgi
LIBCGI_INSTALL_STAGING=YES

$(eval $(call AUTOTARGETS,package,libcgi))
