################################################################################
#
# rng-tools
#
################################################################################

RNG_TOOLS_VERSION = 5
RNG_TOOLS_SITE = http://downloads.sourceforge.net/project/gkernel/rng-tools/$(RNG_TOOLS_VERSION)
RNG_TOOLS_LICENSE = GPLv2
RNG_TOOLS_LICENSE_FILES = COPYING

# Work around for uClibc's lack of argp_*() functions
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
RNG_TOOLS_CONF_ENV += LIBS="-largp"
RNG_TOOLS_DEPENDENCIES += argp-standalone
endif

ifeq ($(BR2_PACKAGE_LIBGCRYPT),y)
RNG_TOOLS_DEPENDENCIES += libgcrypt
else
RNG_TOOLS_CONF_OPTS += --without-libgcrypt
endif

$(eval $(autotools-package))
