################################################################################
#
# docker-proxy
#
################################################################################

DOCKER_PROXY_VERSION = 55685ba49593e67f5e1c8180539379b16736c25e
DOCKER_PROXY_SITE = $(call github,docker,libnetwork,$(DOCKER_PROXY_VERSION))

DOCKER_PROXY_LICENSE = Apache-2.0
DOCKER_PROXY_LICENSE_FILES = LICENSE

DOCKER_PROXY_DEPENDENCIES = host-pkgconf

DOCKER_PROXY_WORKSPACE = gopath

DOCKER_PROXY_BUILD_TARGETS = cmd/proxy

define DOCKER_PROXY_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/bin/proxy $(TARGET_DIR)/usr/bin/docker-proxy
endef

$(eval $(golang-package))
