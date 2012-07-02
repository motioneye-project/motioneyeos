#############################################################
#
# libcgi
#
#############################################################

LIBCGI_VERSION = 1.0
LIBCGI_SITE = http://$(BR2_SOURCEFORGE_MIRROR).dl.sourceforge.net/sourceforge/libcgi
LIBCGI_INSTALL_STAGING = YES
# use cross CC/AR rather than host
LIBCGI_MAKE_ENV = CC="$(TARGET_CC) $(TARGET_CFLAGS)" AR="$(TARGET_AR)"

$(eval $(autotools-package))
