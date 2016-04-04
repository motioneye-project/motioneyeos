################################################################################
#
# go-bootstrap
#
################################################################################

GO_BOOTSTRAP_VERSION = 1.4.2
GO_BOOTSTRAP_SITE = https://storage.googleapis.com/golang
GO_BOOTSTRAP_SOURCE = go$(GO_BOOTSTRAP_VERSION).src.tar.gz

GO_BOOTSTRAP_LICENSE = BSD-3c
GO_BOOTSTRAP_LICENSE_FILES = LICENSE

HOST_GO_BOOTSTRAP_ROOT = $(HOST_DIR)/usr/lib/go-$(GO_BOOTSTRAP_VERSION)

HOST_GO_BOOTSTRAP_MAKE_ENV = \
	GOOS=linux \
	GOROOT_FINAL="$(HOST_GO_BOOTSTRAP_ROOT)" \
	GOROOT="$(@D)" \
	GOBIN="$(@D)/bin"

define HOST_GO_BOOTSTRAP_BUILD_CMDS
	cd $(@D)/src && $(HOST_GO_BOOTSTRAP_MAKE_ENV) ./make.bash
endef

define HOST_GO_BOOTSTRAP_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/go $(HOST_GO_BOOTSTRAP_ROOT)/bin/go
	$(INSTALL) -D -m 0755 $(@D)/bin/gofmt $(HOST_GO_BOOTSTRAP_ROOT)/bin/gofmt

	cp -a $(@D)/lib $(HOST_GO_BOOTSTRAP_ROOT)/
	cp -a $(@D)/pkg $(HOST_GO_BOOTSTRAP_ROOT)/

	# There is a known issue which requires the go sources to be installed
	# https://golang.org/issue/2775
	cp -a $(@D)/src $(HOST_GO_BOOTSTRAP_ROOT)/
endef

$(eval $(host-generic-package))
