################################################################################
#
# runc
#
################################################################################

RUNC_VERSION = 9c2d8d184e5da67c95d601382adf14862e4f2228
RUNC_SITE = $(call github,opencontainers,runc,$(RUNC_VERSION))
RUNC_LICENSE = Apache-2.0
RUNC_LICENSE_FILES = LICENSE

RUNC_DEPENDENCIES = host-go

RUNC_GOPATH = "$(@D)/Godeps/_workspace"
RUNC_MAKE_ENV = $(HOST_GO_TARGET_ENV) \
	CGO_ENABLED=1 \
	GOBIN="$(@D)/bin" \
	GOPATH="$(RUNC_GOPATH)" \
	PATH=$(BR_PATH)

RUNC_GLDFLAGS = \
	-X main.gitCommit=$(RUNC_VERSION)

ifeq ($(BR2_STATIC_LIBS),y)
RUNC_GLDFLAGS += -extldflags '-static'
endif

RUNC_GOTAGS = cgo static_build

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
RUNC_GOTAGS += seccomp
RUNC_DEPENDENCIES += libseccomp host-pkgconf
endif

define RUNC_CONFIGURE_CMDS
	mkdir -p $(RUNC_GOPATH)/src/github.com/opencontainers
	ln -s $(@D) $(RUNC_GOPATH)/src/github.com/opencontainers/runc
endef

define RUNC_BUILD_CMDS
	cd $(@D) && $(RUNC_MAKE_ENV) $(HOST_DIR)/usr/bin/go \
		build -v -o $(@D)/bin/runc \
		-tags "$(RUNC_GOTAGS)" -ldflags "$(RUNC_GLDFLAGS)" .
endef

define RUNC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/runc $(TARGET_DIR)/usr/bin/runc
endef

$(eval $(generic-package))
