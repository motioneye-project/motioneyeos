################################################################################
#
# go
#
################################################################################

GO_VERSION = 1.5.3
GO_SITE = https://storage.googleapis.com/golang
GO_SOURCE = go$(GO_VERSION).src.tar.gz

GO_LICENSE = BSD-3c
GO_LICENSE_FILES = LICENSE

ifeq ($(BR2_arm),y)
GO_GOARCH = arm
ifeq ($(BR2_ARM_CPU_ARMV5),y)
GO_GOARM = 5
else ifeq ($(BR2_ARM_CPU_ARMV6),y)
GO_GOARM = 6
else ifeq ($(BR2_ARM_CPU_ARMV7A),y)
GO_GOARM = 7
endif
else ifeq ($(BR2_aarch64),y)
GO_GOARCH = arm64
else ifeq ($(BR2_i386),y)
GO_GOARCH = 386
else ifeq ($(BR2_x86_64),y)
GO_GOARCH = amd64
else ifeq ($(BR2_powerpc),y)
GO_GOARCH = ppc64
endif

HOST_GO_DEPENDENCIES = host-go-bootstrap
HOST_GO_ROOT = $(HOST_DIR)/usr/lib/go

HOST_GO_MAKE_ENV = \
	GOROOT_BOOTSTRAP=$(HOST_GO_BOOTSTRAP_ROOT) \
	GOROOT_FINAL=$(HOST_GO_ROOT) \
	GOROOT="$(@D)" \
	GOBIN="$(@D)/bin" \
	GOARCH=$(GO_GOARCH) \
	$(if $(GO_GOARM),GOARM=$(GO_GOARM)) \
	GOOS=linux \
	CGO_ENABLED=1 \
	CC_FOR_TARGET=$(TARGET_CC) \
	CXX_FOR_TARGET=$(TARGET_CXX)

define HOST_GO_BUILD_CMDS
	cd $(@D)/src && $(HOST_GO_MAKE_ENV) ./make.bash
endef

define HOST_GO_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/go $(HOST_GO_ROOT)/bin/go
	$(INSTALL) -D -m 0755 $(@D)/bin/gofmt $(HOST_GO_ROOT)/bin/gofmt

	ln -sf ../lib/go/bin/go $(HOST_DIR)/usr/bin/
	ln -sf ../lib/go/bin/gofmt $(HOST_DIR)/usr/bin/

	cp -a $(@D)/lib $(HOST_GO_ROOT)/

	mkdir -p $(HOST_GO_ROOT)/pkg
	cp -a $(@D)/pkg/include $(@D)/pkg/linux_* $(HOST_GO_ROOT)/pkg/
	cp -a $(@D)/pkg/tool $(HOST_GO_ROOT)/pkg/

	# There is a known issue which requires the go sources to be installed
	# https://golang.org/issue/2775
	cp -a $(@D)/src $(HOST_GO_ROOT)/
endef

$(eval $(host-generic-package))
