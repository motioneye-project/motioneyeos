################################################################################
#
# beecrypt
#
################################################################################

BEECRYPT_VERSION = 4.2.1
BEECRYPT_SITE = http://downloads.sourceforge.net/project/beecrypt/beecrypt/$(BEECRYPT_VERSION)
BEECRYPT_AUTORECONF = YES
BEECRYPT_INSTALL_STAGING = YES
BEECRYPT_LICENSE = LGPLv2.1+
BEECRYPT_LICENSE_FILES = COPYING.LIB

BEECRYPT_CONF_OPTS = \
	--disable-expert-mode \
	--without-java \
	--without-python \
	--disable-openmp

# disable optimized m68k assembly as it doesn't compile for coldfire
ifeq ($(BR2_m68k_cf),y)
BEECRYPT_CONF_OPTS += --enable-debug
endif

# arm asm optimization doesn't work for thumb-only
ifeq ($(BR2_arm):$(BR2_ARM_CPU_HAS_ARM),y:)
BEECRYPT_CONF_OPTS += --enable-debug
endif

ifeq ($(BR2_PACKAGE_BEECRYPT_CPP),y)
BEECRYPT_DEPENDENCIES += icu
BEECRYPT_CONF_OPTS += --with-cplusplus
else
BEECRYPT_CONF_OPTS += --without-cplusplus

# automake/libtool uses the C++ compiler to link libbeecrypt because of
# (the optional) cppglue.cxx. Force it to use the C compiler instead.
define BEECRYPT_LINK_WITH_CC
	$(SED) 's/--tag=CXX/--tag=CC/g' $(@D)/Makefile
endef

BEECRYPT_POST_CONFIGURE_HOOKS += BEECRYPT_LINK_WITH_CC
endif

$(eval $(autotools-package))
