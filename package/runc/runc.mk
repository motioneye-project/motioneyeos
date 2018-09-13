################################################################################
#
# runc
#
################################################################################

# docker-engine/hack/dockerfile/install/runc.installer:4 RUNC_COMMIT=...
RUNC_VERSION = 69663f0bd4b60df09991c08812a60108003fa340
RUNC_SITE = $(call github,opencontainers,runc,$(RUNC_VERSION))
RUNC_LICENSE = Apache-2.0
RUNC_LICENSE_FILES = LICENSE

RUNC_WORKSPACE = Godeps/_workspace

RUNC_LDFLAGS = -X main.gitCommit=$(RUNC_VERSION)

RUNC_TAGS = cgo static_build

ifeq ($(BR2_PACKAGE_LIBSECCOMP),y)
RUNC_TAGS += seccomp
RUNC_DEPENDENCIES += libseccomp host-pkgconf
endif

$(eval $(golang-package))
