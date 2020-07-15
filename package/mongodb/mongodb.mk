################################################################################
#
# mongodb
#
################################################################################

MONGODB_VERSION = 4.2.8
MONGODB_SITE = https://fastdl.mongodb.org/src
MONGODB_SOURCE = mongodb-src-r$(MONGODB_VERSION).tar.gz

MONGODB_LICENSE = Apache-2.0 (drivers), SSPL (database)
MONGODB_LICENSE_FILES = APACHE-2.0.txt LICENSE-Community.txt

MONGODB_DEPENDENCIES = \
	boost \
	host-python3-cheetah \
	host-python3-psutil \
	host-python3-pyyaml \
	host-python3-regex \
	host-python3-requests \
	host-scons \
	pcre \
	snappy \
	sqlite \
	yaml-cpp \
	zlib

MONGODB_SCONS_TARGETS = mongod mongos

MONGODB_SCONS_ENV = CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" \
	-j"$(PARALLEL_JOBS)"

MONGODB_SCONS_OPTS = \
	--disable-minimum-compiler-version-enforcement \
	--disable-warnings-as-errors \
	--use-system-boost \
	--use-system-pcre \
	--use-system-snappy \
	--use-system-sqlite \
	--use-system-yaml \
	--use-system-zlib

# need to pass mongo version when not building from git repo
MONGODB_SCONS_OPTS += MONGO_VERSION=$(MONGODB_VERSION)-

# WiredTiger database storage engine only supported on 64 bits
ifeq ($(BR2_ARCH_IS_64),y)
MONGODB_SCONS_OPTS += --wiredtiger=on
else
MONGODB_SCONS_OPTS += --wiredtiger=off
endif

# JavaScript scripting engine and tcmalloc supported only on
# x86/x86-64 systems. Mongo target is a shell interface that
# depends on the javascript engine, so it will also only be
# built on x86/x86-64 systems.
ifeq ($(BR2_i386)$(BR2_x86_64),y)
MONGODB_SCONS_OPTS += --js-engine=mozjs --allocator=tcmalloc
MONGODB_SCONS_TARGETS += mongo
else
MONGODB_SCONS_OPTS += --js-engine=none --allocator=system
endif

ifeq ($(BR2_PACKAGE_LIBCURL),y)
MONGODB_DEPENDENCIES += libcurl
MONGODB_SCONS_OPTS += \
	--enable-free-mon=on \
	--enable-http-client=on
else
MONGODB_SCONS_OPTS += \
	--enable-free-mon=off \
	--enable-http-client=off
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MONGODB_DEPENDENCIES += openssl
MONGODB_SCONS_OPTS += \
	--ssl=on \
	--ssl-provider=openssl
else
MONGODB_SCONS_OPTS += --ssl=off
endif

define MONGODB_BUILD_CMDS
	(cd $(@D); \
		$(HOST_DIR)/bin/python3 $(SCONS) \
		$(MONGODB_SCONS_ENV) \
		$(MONGODB_SCONS_OPTS) \
		$(MONGODB_SCONS_TARGETS))
endef

define MONGODB_INSTALL_TARGET_CMDS
	(cd $(@D); \
		$(HOST_DIR)/bin/python3 $(SCONS) \
		$(MONGODB_SCONS_ENV) \
		$(MONGODB_SCONS_OPTS) \
		--prefix=$(TARGET_DIR)/usr \
		install)
endef

$(eval $(generic-package))
