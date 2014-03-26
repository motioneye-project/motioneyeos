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

# beecrypt contains C++ code that g++ 4.7 doesn't really
# like. Upstream does not seem to be really active, so workaround this
# by passing -fpermissive.
BEECRYPT_CONF_ENV = \
	CXXFLAGS="$(TARGET_CXXFLAGS) -fpermissive"

BEECRYPT_CONF_OPT = \
		--without-java \
		--without-python \
		--disable-openmp

ifeq ($(BR2_PACKAGE_BEECRYPT_CPP),y)
BEECRYPT_DEPENDENCIES += icu
else
BEECRYPT_CONF_OPT += --without-cplusplus

# automake/libtool uses the C++ compiler to link libbeecrypt because of
# (the optional) cppglue.cxx. Force it to use the C compiler instead.
define BEECRYPT_LINK_WITH_CC
	$(SED) 's/--tag=CXX/--tag=CC/g' $(@D)/Makefile
endef

BEECRYPT_POST_CONFIGURE_HOOKS += BEECRYPT_LINK_WITH_CC
endif

$(eval $(autotools-package))
