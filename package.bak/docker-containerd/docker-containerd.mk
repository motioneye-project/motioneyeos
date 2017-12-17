################################################################################
#
# docker-containerd
#
################################################################################

DOCKER_CONTAINERD_VERSION = v0.2.5
DOCKER_CONTAINERD_SITE = $(call github,docker,containerd,$(DOCKER_CONTAINERD_VERSION))
DOCKER_CONTAINERD_LICENSE = Apache-2.0
DOCKER_CONTAINERD_LICENSE_FILES = LICENSE.code

DOCKER_CONTAINERD_DEPENDENCIES = host-go

DOCKER_CONTAINERD_GOPATH = "$(@D)/vendor"
DOCKER_CONTAINERD_MAKE_ENV = $(HOST_GO_TARGET_ENV) \
	CGO_ENABLED=1 \
	GOBIN="$(@D)/bin" \
	GOPATH="$(DOCKER_CONTAINERD_GOPATH)"

DOCKER_CONTAINERD_GLDFLAGS = \
	-X github.com/docker/containerd.GitCommit=$(DOCKER_CONTAINERD_VERSION)

ifeq ($(BR2_STATIC_LIBS),y)
DOCKER_CONTAINERD_GLDFLAGS += -extldflags '-static'
endif

define DOCKER_CONTAINERD_CONFIGURE_CMDS
	mkdir -p $(DOCKER_CONTAINERD_GOPATH)/src/github.com/docker
	ln -s $(@D) $(DOCKER_CONTAINERD_GOPATH)/src/github.com/docker/containerd
	mkdir -p $(DOCKER_CONTAINERD_GOPATH)/src/github.com/opencontainers
	ln -s $(RUNC_SRCDIR) $(DOCKER_CONTAINERD_GOPATH)/src/github.com/opencontainers/runc
endef

define DOCKER_CONTAINERD_BUILD_CMDS
	$(foreach d,ctr containerd containerd-shim,\
		cd $(@D); $(DOCKER_CONTAINERD_MAKE_ENV) $(HOST_DIR)/usr/bin/go build \
			-v -o $(@D)/bin/$(d) -ldflags "$(DOCKER_CONTAINERD_GLDFLAGS)" ./$(d)$(sep))
endef

define DOCKER_CONTAINERD_INSTALL_TARGET_CMDS
	ln -fs runc $(TARGET_DIR)/usr/bin/docker-runc
	$(INSTALL) -D -m 0755 $(@D)/bin/containerd $(TARGET_DIR)/usr/bin/docker-containerd
	$(INSTALL) -D -m 0755 $(@D)/bin/containerd-shim $(TARGET_DIR)/usr/bin/containerd-shim
	ln -fs containerd-shim $(TARGET_DIR)/usr/bin/docker-containerd-shim
endef

$(eval $(generic-package))
