################################################################################
#
# docker-containerd
#
################################################################################

DOCKER_CONTAINERD_VERSION = 9048e5e50717ea4497b757314bad98ea3763c145
DOCKER_CONTAINERD_SITE = $(call github,docker,containerd,$(DOCKER_CONTAINERD_VERSION))
DOCKER_CONTAINERD_LICENSE = Apache-2.0
DOCKER_CONTAINERD_LICENSE_FILES = LICENSE.code

DOCKER_CONTAINERD_WORKSPACE = vendor

DOCKER_CONTAINERD_LDFLAGS = \
	-X github.com/docker/containerd.GitCommit=$(DOCKER_CONTAINERD_VERSION)

DOCKER_CONTAINERD_BUILD_TARGETS = ctr containerd containerd-shim

DOCKER_CONTAINERD_INSTALL_BINS = containerd containerd-shim

define DOCKER_CONTAINERD_INSTALL_SYMLINKS
	ln -fs runc $(TARGET_DIR)/usr/bin/docker-runc
	ln -fs containerd-shim $(TARGET_DIR)/usr/bin/docker-containerd-shim
	ln -fs containerd $(TARGET_DIR)/usr/bin/docker-containerd
endef

DOCKER_CONTAINERD_POST_INSTALL_TARGET_HOOKS += DOCKER_CONTAINERD_INSTALL_SYMLINKS

$(eval $(golang-package))
