#############################################################
#
# enhanced ctorrent
#
#############################################################
CTORRENT_VERSION:=dnh3.3.2
CTORRENT_SOURCE:=ctorrent-$(CTORRENT_VERSION).tar.gz
CTORRENT_SITE:=http://www.rahul.net/dholmes/ctorrent/
CTORRENT_CONF_OPT:=--with-ssl=no

$(eval $(call AUTOTARGETS,package,ctorrent))
