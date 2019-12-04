################################################################################
#
# sysrepo
#
################################################################################

SYSREPO_VERSION = 0.7.8
SYSREPO_SITE = $(call github,sysrepo,sysrepo,v$(SYSREPO_VERSION))
SYSREPO_INSTALL_STAGING = YES
SYSREPO_LICENSE = Apache-2.0
SYSREPO_LICENSE_FILES = LICENSE
SYSREPO_DEPENDENCIES = libev libavl libyang pcre protobuf-c host-sysrepo
HOST_SYSREPO_DEPENDENCIES = host-libev host-libavl host-libyang host-pcre host-protobuf-c

SYSREPO_CONF_OPTS = \
	-DIS_DEVELOPER_CONFIGURATION=OFF \
	-DGEN_PYTHON2_TESTS=OFF \
	-DENABLE_TESTS=OFF \
	-DGEN_CPP_BINDINGS=OFF \
	-DGEN_LANGUAGE_BINDINGS=OFF \
	-DGEN_PYTHON_BINDINGS=OFF \
	-DBUILD_CPP_EXAMPLES=OFF \
	-DCALL_SYSREPOCTL_BIN=$(HOST_DIR)/bin/sysrepoctl \
	-DCALL_SYSREPOCFG_BIN=$(HOST_DIR)/bin/sysrepocfg \
	-DBUILD_EXAMPLES=$(if $(BR2_PACKAGE_SYSREPO_EXAMPLES),ON,OFF) \
	$(if $(BR2_INIT_SYSTEMD),-DWITH_SYSTEMD=ON) \
	$(if $(BR2_INIT_SYSTEMD),-DSYSTEMD_UNIT_DIR=usr/lib/systemd/system)

# On ARM, this is needed to prevent unaligned memory access with an optimized
# build .. https://github.com/sysrepo/sysrepo/issues/947
SYSREPO_CONF_OPTS += -DUSE_SR_MEM_MGMT=OFF

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
SYSREPO_CONF_OPTS += -DCMAKE_EXE_LINKER_FLAGS=-latomic
endif

define SYSREPO_INSTALL_INIT_SYSV
	$(INSTALL) -m 755 -D package/sysrepo/S50sysrepod \
		$(TARGET_DIR)/etc/init.d/S50sysrepod
	$(INSTALL) -m 755 -D package/sysrepo/S51sysrepo-plugind \
		$(TARGET_DIR)/etc/init.d/S51sysrepo-plugind
endef

define SYSREPO_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/sysrepod.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib/systemd/system/sysrepo-plugind.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
endef

HOST_SYSREPO_CONF_OPTS = \
	-DGEN_PYTHON2_TESTS=OFF \
	-DENABLE_TESTS=OFF \
	-DGEN_CPP_BINDINGS=OFF \
	-DGEN_LANGUAGE_BINDINGS=OFF \
	-DGEN_PYTHON_BINDINGS=OFF \
	-DCALL_TARGET_BINS_DIRECTLY=OFF \
	-DBUILD_EXAMPLES=OFF \
	-DBUILD_CPP_EXAMPLES=OFF \
	-DREPOSITORY_LOC=$(HOST_DIR)/etc/sysrepo \
	-DSUBSCRIPTIONS_SOCKET_DIR=$(HOST_DIR)/var/run/sysrepo-subscriptions

$(eval $(cmake-package))
$(eval $(host-cmake-package))
