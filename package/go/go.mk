################################################################################
#
# go
#
################################################################################

GO_VERSION = 1.9
GO_SITE = https://storage.googleapis.com/golang
GO_SOURCE = go$(GO_VERSION).src.tar.gz

GO_LICENSE = BSD-3-Clause
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
else ifeq ($(BR2_powerpc64),y)
GO_GOARCH = ppc64
else ifeq ($(BR2_powerpc64le),y)
GO_GOARCH = ppc64le
else ifeq ($(BR2_mips64),y)
GO_GOARCH = mips64
else ifeq ($(BR2_mips64el),y)
GO_GOARCH = mips64le
endif

HOST_GO_DEPENDENCIES = host-go-bootstrap
HOST_GO_ROOT = $(HOST_DIR)/lib/go

# For the convienience of target packages.
HOST_GO_TOOLDIR = $(HOST_GO_ROOT)/pkg/tool/linux_$(GO_GOARCH)
HOST_GO_TARGET_ENV = \
	GOARCH=$(GO_GOARCH) \
	GOROOT="$(HOST_GO_ROOT)" \
	CC="$(TARGET_CC)" \
	CXX="$(TARGET_CXX)" \
	GOTOOLDIR="$(HOST_GO_TOOLDIR)"

# The go compiler's cgo support uses threads.  If BR2_TOOLCHAIN_HAS_THREADS is
# set, build in cgo support for any go programs that may need it.  Note that
# any target package needing cgo support must include
# 'depends on BR2_TOOLCHAIN_HAS_THREADS' in its config file.
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
HOST_GO_CGO_ENABLED = 1
else
HOST_GO_CGO_ENABLED = 0
endif

# The go build system doesn't have the notion of cross compiling, but just the
# notion of architecture.  When the host and target architectures are different
# it expects to be given a target cross compiler in CC_FOR_TARGET.  When the
# architectures are the same it will use CC_FOR_TARGET for both host and target
# compilation.  To work around this limitation build and install a set of
# compiler and tool binaries built with CC_FOR_TARGET set to the host compiler.
# Also, the go build system is not compatible with ccache, so use
# HOSTCC_NOCCACHE.  See https://github.com/golang/go/issues/11685.
HOST_GO_MAKE_ENV = \
	GOROOT_BOOTSTRAP=$(HOST_GO_BOOTSTRAP_ROOT) \
	GOROOT_FINAL=$(HOST_GO_ROOT) \
	GOROOT="$(@D)" \
	GOBIN="$(@D)/bin" \
	GOARCH=$(GO_GOARCH) \
	$(if $(GO_GOARM),GOARM=$(GO_GOARM)) \
	GOOS=linux \
	CC=$(HOSTCC_NOCCACHE) \
	CXX=$(HOSTCXX_NOCCACHE)

HOST_GO_TARGET_CC = \
	CC_FOR_TARGET="$(TARGET_CC)" \
	CXX_FOR_TARGET="$(TARGET_CXX)"

HOST_GO_HOST_CC = \
	CC_FOR_TARGET=$(HOSTCC_NOCCACHE) \
	CXX_FOR_TARGET=$(HOSTCXX_NOCCACHE)

HOST_GO_TMP = $(@D)/host-go-tmp

define HOST_GO_BUILD_CMDS
	cd $(@D)/src && \
		$(HOST_GO_MAKE_ENV) $(HOST_GO_HOST_CC) CGO_ENABLED=0 ./make.bash
	mkdir -p $(HOST_GO_TMP)
	mv $(@D)/pkg/tool $(HOST_GO_TMP)/
	mv $(@D)/bin/ $(HOST_GO_TMP)/
	cd $(@D)/src && \
		$(HOST_GO_MAKE_ENV) $(HOST_GO_TARGET_CC) CGO_ENABLED=$(HOST_GO_CGO_ENABLED) ./make.bash
endef

define HOST_GO_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(HOST_GO_TMP)/bin/go $(HOST_GO_ROOT)/bin/go
	$(INSTALL) -D -m 0755 $(HOST_GO_TMP)/bin/gofmt $(HOST_GO_ROOT)/bin/gofmt

	ln -sf ../lib/go/bin/go $(HOST_DIR)/bin/
	ln -sf ../lib/go/bin/gofmt $(HOST_DIR)/bin/

	cp -a $(@D)/lib $(HOST_GO_ROOT)/

	mkdir -p $(HOST_GO_ROOT)/pkg
	cp -a $(@D)/pkg/include $(@D)/pkg/linux_* $(HOST_GO_ROOT)/pkg/
	cp -a $(HOST_GO_TMP)/tool $(HOST_GO_ROOT)/pkg/

	# There is a known issue which requires the go sources to be installed
	# https://golang.org/issue/2775
	cp -a $(@D)/src $(HOST_GO_ROOT)/

	# Set all file timestamps to prevent the go compiler from rebuilding any
	# built in packages when programs are built.
	find $(HOST_GO_ROOT) -type f -exec touch -r $(HOST_GO_TMP)/bin/go {} \;
endef

$(eval $(host-generic-package))
