#############################################################
#
# ccache
#
#############################################################

CCACHE_VERSION = 3.1.4
CCACHE_SITE    = http://samba.org/ftp/ccache
CCACHE_SOURCE  = ccache-$(CCACHE_VERSION).tar.bz2

# When ccache is being built for the host, ccache is not yet
# available, so we have to use the special C compiler without the
# cache.
HOST_CCACHE_CONF_ENV = \
	CC="$(HOSTCC_NOCCACHE)"

# We directly hardcode the cache location into the binary, as it is
# much easier to handle than passing an environment variable.
define HOST_CCACHE_FIX_CCACHE_DIR
	sed -i 's,getenv("CCACHE_DIR"),"$(CCACHE_CACHE_DIR)",' $(@D)/ccache.c
endef

HOST_CCACHE_POST_CONFIGURE_HOOKS += \
	HOST_CCACHE_FIX_CCACHE_DIR

$(eval $(call AUTOTARGETS,package,ccache))
$(eval $(call AUTOTARGETS,package,ccache,host))

ifeq ($(BR2_CCACHE),y)
ccache-stats: host-ccache
	$(Q)$(CCACHE) -s
endif

