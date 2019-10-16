################################################################################
#
# bird
#
################################################################################

BIRD_VERSION = 2.0.7
BIRD_SITE = ftp://bird.network.cz/pub/bird
BIRD_LICENSE = GPL-2.0+
BIRD_LICENSE_FILES = README
BIRD_DEPENDENCIES = host-flex host-bison

ifeq ($(BR2_PACKAGE_BIRD_CLIENT),y)
BIRD_CONF_OPTS += --enable-client
BIRD_DEPENDENCIES += ncurses readline
else
BIRD_CONF_OPTS += --disable-client
endif

BIRD_PROTOCOLS = \
	$(if $(BR2_PACKAGE_BIRD_BFD),bfd) \
	$(if $(BR2_PACKAGE_BIRD_BABEL),babel) \
	$(if $(BR2_PACKAGE_BIRD_BGP),bgp) \
	$(if $(BR2_PACKAGE_BIRD_MRT),mrt) \
	$(if $(BR2_PACKAGE_BIRD_OSPF),ospf) \
	$(if $(BR2_PACKAGE_BIRD_PERF),perf) \
	$(if $(BR2_PACKAGE_BIRD_PIPE),pipe) \
	$(if $(BR2_PACKAGE_BIRD_RADV),radv) \
	$(if $(BR2_PACKAGE_BIRD_RIP),rip) \
	$(if $(BR2_PACKAGE_BIRD_STATIC),static)

BIRD_CONF_OPTS += --with-protocols=$(subst $(space),$(comma),$(strip $(BIRD_PROTOCOLS)))

$(eval $(autotools-package))
