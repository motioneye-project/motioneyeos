################################################################################
#
# ccache
#
################################################################################

CCACHE_VERSION = 3.3.4
CCACHE_SITE = https://www.samba.org/ftp/ccache
CCACHE_SOURCE = ccache-$(CCACHE_VERSION).tar.xz
CCACHE_LICENSE = GPL-3.0+, others
CCACHE_LICENSE_FILES = LICENSE.txt GPL-3.0.txt

# Force ccache to use its internal zlib. The problem is that without
# this, ccache would link against the zlib of the build system, but we
# might build and install a different version of zlib in $(O)/host
# afterwards, which ccache will pick up. This might break if there is
# a version mismatch. A solution would be to add host-zlib has a
# dependency of ccache, but it would require tuning the zlib .mk file
# to use HOSTCC_NOCCACHE as the compiler. Instead, we take the easy
# path: tell ccache to use its internal copy of zlib, so that ccache
# has zero dependency besides the C library.
HOST_CCACHE_CONF_OPTS += --with-bundled-zlib

# Patch host-ccache as follows:
#  - Use BR_CACHE_DIR instead of CCACHE_DIR, because CCACHE_DIR
#    is already used by autotargets for the ccache package.
#    BR_CACHE_DIR is exported by Makefile based on config option
#    BR2_CCACHE_DIR.
#  - Change hard-coded last-ditch default to match path in .config, to avoid
#    the need to specify BR_CACHE_DIR when invoking ccache directly.
define HOST_CCACHE_PATCH_CONFIGURATION
	sed -i 's,getenv("CCACHE_DIR"),getenv("BR_CACHE_DIR"),' $(@D)/ccache.c
	sed -i 's,"%s/.ccache","$(BR_CACHE_DIR)",' $(@D)/conf.c
endef

HOST_CCACHE_POST_PATCH_HOOKS += HOST_CCACHE_PATCH_CONFIGURATION

define HOST_CCACHE_MAKE_CACHE_DIR
	mkdir -p $(BR_CACHE_DIR)
endef

HOST_CCACHE_POST_INSTALL_HOOKS += HOST_CCACHE_MAKE_CACHE_DIR

# Provide capability to do initial ccache setup (e.g. increase default size)
BR_CCACHE_INITIAL_SETUP = $(call qstrip,$(BR2_CCACHE_INITIAL_SETUP))
ifneq ($(BR_CCACHE_INITIAL_SETUP),)
define HOST_CCACHE_DO_INITIAL_SETUP
	@$(call MESSAGE,"Applying initial settings")
	$(CCACHE) $(BR_CCACHE_INITIAL_SETUP)
	$(CCACHE) -s
endef

HOST_CCACHE_POST_INSTALL_HOOKS += HOST_CCACHE_DO_INITIAL_SETUP
endif

$(eval $(host-autotools-package))

ifeq ($(BR2_CCACHE),y)
ccache-stats: host-ccache
	$(Q)$(CCACHE) -s

ccache-options: host-ccache
ifeq ($(CCACHE_OPTIONS),)
	$(Q)echo "Usage: make ccache-options CCACHE_OPTIONS=\"opts\""
	$(Q)echo "where 'opts' corresponds to one or more valid ccache options" \
	"(see ccache help text below)"
	$(Q)echo
endif
	$(Q)$(CCACHE) $(CCACHE_OPTIONS)
endif
