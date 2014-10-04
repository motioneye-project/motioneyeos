################################################################################
#
# leafnode2
#
################################################################################

LEAFNODE2_VERSION = 2.0.0.alpha20140727b
LEAFNODE2_SOURCE = leafnode-$(LEAFNODE2_VERSION).tar.bz2
LEAFNODE2_SITE = http://home.pages.de/~mandree/leafnode/beta
LEAFNODE2_LICENSE = LGPLv2.1
LEAFNODE2_LICENSE_FILES = COPYING COPYING.LGPL
LEAFNODE2_DEPENDENCIES = host-pcre pcre

LEAFNODE2_CONF_ENV = \
	PCRECONFIG="$(STAGING_DIR)/usr/bin/pcre-config"

LEAFNODE2_CONF_OPTS = \
	--sysconfdir=/etc/leafnode2 \
	--enable-spooldir=/var/spool/news

# Leafnode2 needs the host version of b_sortnl during
# compilation. Instead of creating a seperate host package and
# installing b_sortnl to $(HOST_DIR) this binary is compiled
# on-the-fly, host-pcre is needed for this
define LEAFNODE2_BUILD_SORTNL_TOOL
	cd $(@D); \
	$(HOSTCC) $(HOST_CFLAGS) -o b_sortnl_host \
		arc4random.c mergesort.c b_sortnl.c critmem_malloc.c \
		critmem_realloc.c -DHAVE_CONFIG_H -I$(HOST_DIR)/usr/include \
		-L $(HOST_DIR)/usr/lib -Wl,-rpath,$(HOST_DIR)/usr/lib -lpcre
endef

LEAFNODE2_PRE_BUILD_HOOKS += LEAFNODE2_BUILD_SORTNL_TOOL

define LEAFNODE2_USERS
	news -1 news -1 * - - - Leafnode2 daemon
endef

$(eval $(autotools-package))
