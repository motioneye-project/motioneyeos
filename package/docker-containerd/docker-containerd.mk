################################################################################
#
# docker-containerd
#
################################################################################

DOCKER_CONTAINERD_VERSION = 1.2.13
DOCKER_CONTAINERD_SITE = $(call github,containerd,containerd,v$(DOCKER_CONTAINERD_VERSION))
DOCKER_CONTAINERD_LICENSE = Apache-2.0
DOCKER_CONTAINERD_LICENSE_FILES = LICENSE

DOCKER_CONTAINERD_WORKSPACE = vendor

DOCKER_CONTAINERD_LDFLAGS = \
	-X github.com/docker/containerd.GitCommit=$(DOCKER_CONTAINERD_VERSION)

DOCKER_CONTAINERD_BUILD_TARGETS = cmd/ctr cmd/containerd cmd/containerd-shim

DOCKER_CONTAINERD_INSTALL_BINS = containerd containerd-shim

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
DOCKER_CONTAINERD_DEPENDENCIES += libseccomp host-pkgconf
DOCKER_CONTAINERD_TAGS += seccomp
endif

ifeq ($(BR2_PACKAGE_DOCKER_CONTAINERD_DRIVER_BTRFS),y)
DOCKER_CONTAINERD_DEPENDENCIES += btrfs-progs
else
DOCKER_CONTAINERD_TAGS += no_btrfs
endif

define DOCKER_CONTAINERD_INSTALL_SYMLINKS
	ln -fs runc $(TARGET_DIR)/usr/bin/docker-runc
	ln -fs containerd-shim $(TARGET_DIR)/usr/bin/docker-containerd-shim
	ln -fs containerd $(TARGET_DIR)/usr/bin/docker-containerd
endef

DOCKER_CONTAINERD_POST_INSTALL_TARGET_HOOKS += DOCKER_CONTAINERD_INSTALL_SYMLINKS

$(eval $(golang-package))
