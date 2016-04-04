################################################################################
#
# flannel
#
################################################################################

FLANNEL_VERSION = v0.5.5
FLANNEL_SITE = https://github.com/coreos/flannel/archive
FLANNEL_SOURCE = $(FLANNEL_VERSION).tar.gz

FLANNEL_LICENSE = Apache-2.0
FLANNEL_LICENSE_FILES = LICENSE

FLANNEL_DEPENDENCIES = host-go

FLANNEL_MAKE_ENV = \
	GOBIN="$(@D)/bin" \
	GOPATH="$(@D)/gopath" \
	GOARCH=$(GO_GOARCH) \
	CGO_ENABLED=1

FLANNEL_GLDFLAGS = \
	-X github.com/coreos/flannel/version.Version=$(FLANNEL_VERSION) \
	-extldflags '-static'

define FLANNEL_CONFIGURE_CMDS
	# Put sources at prescribed GOPATH location.
	mkdir -p $(@D)/gopath/src/github.com/coreos
	ln -s $(@D) $(@D)/gopath/src/github.com/coreos/flannel
endef

define FLANNEL_BUILD_CMDS
	cd $(@D) && $(FLANNEL_MAKE_ENV) $(HOST_DIR)/usr/bin/go \
		build -v -o $(@D)/bin/flanneld -ldflags "$(FLANNEL_GLDFLAGS)" .
endef

define FLANNEL_INSTALL_TARGET_CMDS
	# Install flannel to its well known location.
	$(INSTALL) -D -m 0755 $(@D)/bin/flanneld $(TARGET_DIR)/opt/bin/flanneld
	$(INSTALL) -D -m 0755 $(@D)/dist/mk-docker-opts.sh $(TARGET_DIR)/opt/bin/mk-docker-opts.sh
endef

$(eval $(generic-package))
