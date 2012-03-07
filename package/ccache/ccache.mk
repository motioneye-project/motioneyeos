#############################################################
#
# ccache
#
#############################################################

CCACHE_VERSION = 3.1.7
CCACHE_SITE    = http://samba.org/ftp/ccache
CCACHE_SOURCE  = ccache-$(CCACHE_VERSION).tar.bz2

# When ccache is being built for the host, ccache is not yet
# available, so we have to use the special C compiler without the
# cache.
HOST_CCACHE_CONF_ENV = \
	CC="$(HOSTCC_NOCCACHE)"

# Force ccache to use its internal zlib. The problem is that without
# this, ccache would link against the zlib of the build system, but we
# might build and install a different version of zlib in $(O)/host
# afterwards, which ccache will pick up. This might break if there is
# a version mismatch. A solution would be to add host-zlib has a
# dependency of ccache, but it would require tuning the zlib .mk file
# to use HOSTCC_NOCCACHE as the compiler. Instead, we take the easy
# path: tell ccache to use its internal copy of zlib, so that ccache
# has zero dependency besides the C library.
HOST_CCACHE_CONF_OPT += ccache_cv_zlib_1_2_3=no

# We directly hardcode configuration into the binary, as it is much
# easier to handle than passing an environment variable. Our
# configuration is:
#  - the cache location
#  - the fact that ccache shouldn't use the compiler binary mtime to
#  - detect a change in the compiler, because in the context of
#  - Buildroot, that completely defeats the purpose of ccache. Of
#  - course, that leaves the user responsible for purging its cache
#  - when the compiler changes.
define HOST_CCACHE_FIX_CCACHE_DIR
	sed -i 's,getenv("CCACHE_DIR"),"$(CCACHE_CACHE_DIR)",' $(@D)/ccache.c
	sed -i 's,getenv("CCACHE_COMPILERCHECK"),"none",' $(@D)/ccache.c
endef

HOST_CCACHE_POST_CONFIGURE_HOOKS += \
	HOST_CCACHE_FIX_CCACHE_DIR

$(eval $(call AUTOTARGETS))
$(eval $(call AUTOTARGETS,host))

ifeq ($(BR2_CCACHE),y)
ccache-stats: host-ccache
	$(Q)$(CCACHE) -s
endif

