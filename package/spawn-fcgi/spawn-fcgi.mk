#############################################################
#
# spawn-fcgi
#
#############################################################

SPAWN_FCGI_VERSION = 1.6.3
SPAWN_FCGI_SITE = http://www.lighttpd.net/download
SPAWN_FCGI_SOURCE = spawn-fcgi-$(SPAWN_FCGI_VERSION).tar.bz2

ifneq ($(BR2_INET_IPV6),y)
SPAWN_FCGI_CONF_OPT = --disable-ipv6
endif

$(eval $(call AUTOTARGETS,package,spawn-fcgi))
