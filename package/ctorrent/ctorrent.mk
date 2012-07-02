#############################################################
#
# enhanced ctorrent
#
#############################################################
CTORRENT_VERSION:=dnh3.3.2
CTORRENT_SOURCE:=ctorrent-$(CTORRENT_VERSION).tar.gz
CTORRENT_SITE:=http://www.rahul.net/dholmes/ctorrent/

ifeq ($(BR2_PACKAGE_OPENSSL),y)
CTORRENT_CONF_OPT+=--with-ssl=yes
CTORRENT_DEPENDENCIES+=openssl
else
CTORRENT_CONF_OPT+=--with-ssl=no
endif

$(eval $(autotools-package))
