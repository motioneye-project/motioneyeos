################################################################################
#
# mongodb
#
################################################################################

MONGODB_VERSION_BASE = 3.2.0
MONGODB_VERSION = r$(MONGODB_VERSION_BASE)
MONGODB_SITE = $(call github,mongodb,mongo,$(MONGODB_VERSION))

MONGODB_LICENSE = AGPLv3, Apache-2.0
MONGODB_LICENSE_FILES = GNU-AGPL-3.0.txt APACHE-2.0.txt

MONGODB_DEPENDENCIES = host-scons

MONGODB_SCONS_TARGETS = mongod mongos

MONGODB_SCONS_ENV = CC="$(TARGET_CC)" CXX="$(TARGET_CXX)" \
	-j"$(PARALLEL_JOBS)"

MONGODB_SCONS_OPTS = --disable-warnings-as-errors

# need to pass mongo version when not building from git repo
MONGODB_SCONS_OPTS += MONGO_VERSION=$(MONGODB_VERSION_BASE)-

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

ifeq ($(BR2_PACKAGE_OPENSSL),y)
MONGODB_DEPENDENCIES += openssl
MONGODB_SCONS_OPTS += --ssl=SSL
endif

define MONGODB_BUILD_CMDS
	(cd $(@D); \
		$(SCONS) \
		$(MONGODB_SCONS_ENV) \
		$(MONGODB_SCONS_OPTS) \
		$(MONGODB_SCONS_TARGETS))
endef

define MONGODB_INSTALL_TARGET_CMDS
	(cd $(@D); \
		$(SCONS) \
		$(MONGODB_SCONS_ENV) \
		$(MONGODB_SCONS_OPTS) \
		--prefix=$(TARGET_DIR)/usr \
		install)
endef

$(eval $(generic-package))
