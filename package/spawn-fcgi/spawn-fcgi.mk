################################################################################
#
# spawn-fcgi
#
################################################################################

SPAWN_FCGI_VERSION = 1.6.4
SPAWN_FCGI_SITE = http://www.lighttpd.net/download
SPAWN_FCGI_SOURCE = spawn-fcgi-$(SPAWN_FCGI_VERSION).tar.bz2
SPAWN_FCGI_LICENSE = BSD-3c
SPAWN_FCGI_LICENSE_FILES = COPYING

ifneq ($(BR2_INET_IPV6),y)
SPAWN_FCGI_CONF_OPTS = --disable-ipv6
endif

$(eval $(autotools-package))
