################################################################################
#
# nettle
#
################################################################################

NETTLE_VERSION = 2.7.1
NETTLE_SITE = http://www.lysator.liu.se/~nisse/archive
NETTLE_DEPENDENCIES = gmp
NETTLE_INSTALL_STAGING = YES
NETTLE_LICENSE = LGPLv2.1+
NETTLE_LICENSE_FILES = COPYING.LIB
# don't include openssl support for (unused) examples as it has problems
# with static linking
NETTLE_CONF_OPT = --disable-openssl

# ARM assembly requires v6+ ISA
ifeq ($(BR2_arm7tdmi)$(BR2_arm720t)$(BR2_arm920t)$(BR2_arm922t)$(BR2_arm926t)$(BR2_arm10t)$(BR2_fa526)$(BR2_strongarm)$(BR2_xscale)$(BR2_iwmmxt),y)
NETTLE_CONF_OPT += --disable-assembler
endif

# ARM NEON, requires binutils 2.21+
ifeq ($(BR2_ARM_CPU_HAS_NEON)$(BR2_TOOLCHAIN_BUILDROOT)$(BR2_BINUTILS_VERSION_2_20_1),yy)
NETTLE_CONF_OPT += --enable-arm-neon
else
NETTLE_CONF_OPT += --disable-arm-neon
endif

define NETTLE_DITCH_DEBUGGING_CFLAGS
	$(SED) '/CFLAGS/ s/ -ggdb3//' $(@D)/configure
endef

NETTLE_POST_EXTRACT_HOOKS += NETTLE_DITCH_DEBUGGING_CFLAGS

$(eval $(autotools-package))
