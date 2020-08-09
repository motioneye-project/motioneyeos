################################################################################
#
# botan
#
################################################################################

BOTAN_VERSION = 2.14.0
BOTAN_SOURCE = Botan-$(BOTAN_VERSION).tar.xz
BOTAN_SITE = http://botan.randombit.net/releases
BOTAN_LICENSE = BSD-2-Clause
BOTAN_LICENSE_FILES = license.txt

BOTAN_INSTALL_STAGING = YES

BOTAN_CONF_OPTS = \
	--cpu=$(BR2_ARCH) \
	--os=linux \
	--cc=gcc \
	--cc-bin="$(TARGET_CXX)" \
	--ldflags="$(BOTAN_LDFLAGS)" \
	--prefix=/usr \
	--without-documentation

BOTAN_LDFLAGS = $(TARGET_LDFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
BOTAN_LDFLAGS += -latomic
endif

ifeq ($(BR2_SHARED_LIBS),y)
BOTAN_CONF_OPTS += \
	--disable-static-library \
	--enable-shared-library
else ifeq ($(BR2_STATIC_LIBS),y)
BOTAN_CONF_OPTS += \
	--disable-shared-library \
	--enable-static-library \
	--no-autoload
else ifeq ($(BR2_SHARED_STATIC_LIBS),y)
BOTAN_CONF_OPTS += \
	--enable-shared-library \
	--enable-static-library
endif

ifeq ($(BR2_TOOLCHAIN_HAS_SSP),y)
BOTAN_CONF_OPTS += --with-stack-protector
else
BOTAN_CONF_OPTS += --without-stack-protector
endif

ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
BOTAN_CONF_OPTS += --without-os-feature=getauxval
endif

ifeq ($(BR2_PACKAGE_BOOST),y)
BOTAN_DEPENDENCIES += boost
BOTAN_CONF_OPTS += --with-boost
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
BOTAN_DEPENDENCIES += bzip2
BOTAN_CONF_OPTS += --with-bzip2
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
BOTAN_DEPENDENCIES += openssl
BOTAN_CONF_OPTS += --with-openssl
endif

ifeq ($(BR2_PACKAGE_SQLITE),y)
BOTAN_DEPENDENCIES += sqlite
BOTAN_CONF_OPTS += --with-sqlite
endif

ifeq ($(BR2_PACKAGE_XZ),y)
BOTAN_DEPENDENCIES += xz
BOTAN_CONF_OPTS += --with-lzma
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
BOTAN_DEPENDENCIES += zlib
BOTAN_CONF_OPTS += --with-zlib
endif

ifeq ($(BR2_POWERPC_CPU_HAS_ALTIVEC),)
BOTAN_CONF_OPTS += --disable-altivec
endif

ifeq ($(BR2_ARM_CPU_HAS_NEON),)
BOTAN_CONF_OPTS += --disable-neon
endif

define BOTAN_CONFIGURE_CMDS
	(cd $(@D); $(TARGET_MAKE_ENV) ./configure.py $(BOTAN_CONF_OPTS))
endef

define BOTAN_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) AR="$(TARGET_AR)"
endef

define BOTAN_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(STAGING_DIR)" install
endef

define BOTAN_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) DESTDIR="$(TARGET_DIR)" install
endef

$(eval $(generic-package))
