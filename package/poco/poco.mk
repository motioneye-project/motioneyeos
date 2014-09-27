################################################################################
#
# poco
#
################################################################################

POCO_VERSION_MAJOR = 1.4.6
POCO_VERSION = $(POCO_VERSION_MAJOR)p1
POCO_SOURCE = poco-$(POCO_VERSION)-all.tar.gz
POCO_SITE = http://downloads.sourceforge.net/project/poco/sources/poco-$(POCO_VERSION_MAJOR)
POCO_LICENSE = Boost-v1.0
POCO_LICENSE_FILES = LICENSE
POCO_INSTALL_STAGING = YES

POCO_DEPENDENCIES = zlib pcre					\
	$(if $(BR2_PACKAGE_POCO_XML),expat)			\
	$(if $(BR2_PACKAGE_POCO_CRYPTO),openssl)		\
	$(if $(BR2_PACKAGE_POCO_NETSSL_OPENSSL),openssl)	\
	$(if $(BR2_PACKAGE_POCO_DATA_SQLITE),sqlite)		\
	$(if $(BR2_PACKAGE_POCO_DATA_MYSQL),mysql)

POCO_OMIT = Data/ODBC PageCompiler					\
	$(if $(BR2_PACKAGE_POCO_XML),,XML)				\
	$(if $(BR2_PACKAGE_POCO_UTIL),,Util)				\
	$(if $(BR2_PACKAGE_POCO_NET),,Net)				\
	$(if $(BR2_PACKAGE_POCO_NETSSL_OPENSSL),,NetSSL_OpenSSL)	\
	$(if $(BR2_PACKAGE_POCO_CRYPTO),,Crypto)			\
	$(if $(BR2_PACKAGE_POCO_ZIP),,Zip)				\
	$(if $(BR2_PACKAGE_POCO_DATA),,Data)				\
	$(if $(BR2_PACKAGE_POCO_DATA_MYSQL),,Data/MySQL)		\
	$(if $(BR2_PACKAGE_POCO_DATA_SQLITE),,Data/SQLite)

ifeq ($(LIBC),uclibc)
POCO_CONF_OPTS += --no-fpenvironment --no-wstring
endif

# architectures missing some FE_* in their fenv.h
ifeq ($(BR2_sh4a)$(BR2_nios2),y)
POCO_CONF_OPTS += --no-fpenvironment
endif

define POCO_CONFIGURE_CMDS
	(cd $(@D); ./configure \
		--config=Linux-CrossEnv	\
		--prefix=/usr		\
		--omit="$(POCO_OMIT)"	\
		$(POCO_CONF_OPTS)	\
		--unbundled		\
		--no-tests		\
		--no-samples)
endef

define POCO_BUILD_CMDS
	$(MAKE1) POCO_TARGET_OSARCH=$(ARCH) CROSSENV=$(TARGET_CROSS) \
		MYSQL_LIBDIR=$(STAGING_DIR)/usr/lib/mysql \
		MYSQL_INCDIR=$(STAGING_DIR)/usr/include/mysql -C $(@D)
endef

define POCO_INSTALL_STAGING_CMDS
	$(MAKE) DESTDIR=$(STAGING_DIR) POCO_TARGET_OSARCH=$(ARCH) install -C $(@D)
endef

define POCO_INSTALL_TARGET_CMDS
	$(MAKE) DESTDIR=$(TARGET_DIR) POCO_TARGET_OSARCH=$(ARCH) install -C $(@D)
endef

$(eval $(generic-package))
