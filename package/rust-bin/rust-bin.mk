################################################################################
#
# rust-bin
#
################################################################################

RUST_BIN_VERSION = 1.29.2
RUST_BIN_SITE = https://static.rust-lang.org/dist
RUST_BIN_LICENSE = Apache-2.0 or MIT
RUST_BIN_LICENSE_FILES = LICENSE-APACHE LICENSE-MIT

HOST_RUST_BIN_PROVIDES = host-rustc

HOST_RUST_BIN_SOURCE = rustc-$(RUST_BIN_VERSION)-$(RUSTC_HOST_NAME).tar.xz

HOST_RUST_BIN_EXTRA_DOWNLOADS = \
	rust-std-$(RUST_BIN_VERSION)-$(RUSTC_HOST_NAME).tar.xz

ifeq ($(BR2_PACKAGE_HOST_RUSTC_TARGET_ARCH_SUPPORTS),y)
HOST_RUST_BIN_EXTRA_DOWNLOADS += rust-std-$(RUST_BIN_VERSION)-$(RUSTC_TARGET_NAME).tar.xz
endif

HOST_RUST_BIN_LIBSTD_HOST_PREFIX = rust-std-$(RUST_BIN_VERSION)-$(RUSTC_HOST_NAME)/rust-std-$(RUSTC_HOST_NAME)

define HOST_RUST_BIN_LIBSTD_EXTRACT
	mkdir -p $(@D)/std
	$(foreach f,$(HOST_RUST_BIN_EXTRA_DOWNLOADS), \
		$(call suitable-extractor,$(f)) $(HOST_RUST_BIN_DL_DIR)/$(f) | \
			$(TAR) -C $(@D)/std $(TAR_OPTIONS) -
	)
	cd $(@D)/rustc/lib/rustlib/$(RUSTC_HOST_NAME); \
		ln -sf ../../../../std/$(HOST_RUST_BIN_LIBSTD_HOST_PREFIX)/lib/rustlib/$(RUSTC_HOST_NAME)/lib
endef

HOST_RUST_BIN_POST_EXTRACT_HOOKS += HOST_RUST_BIN_LIBSTD_EXTRACT

HOST_RUST_BIN_INSTALL_OPTS = \
	--prefix=$(HOST_DIR) \
	--disable-ldconfig

define HOST_RUST_BIN_INSTALL_RUSTC
	(cd $(@D); \
		./install.sh $(HOST_RUST_BIN_INSTALL_OPTS))
endef

define HOST_RUST_BIN_INSTALL_LIBSTD_HOST
	(cd $(@D)/std/rust-std-$(RUST_BIN_VERSION)-$(RUSTC_HOST_NAME); \
		./install.sh $(HOST_RUST_BIN_INSTALL_OPTS))
endef

ifeq ($(BR2_PACKAGE_HOST_RUSTC_TARGET_ARCH_SUPPORTS),y)
define HOST_RUST_BIN_INSTALL_LIBSTD_TARGET
	(cd $(@D)/std/rust-std-$(RUST_BIN_VERSION)-$(RUSTC_TARGET_NAME); \
		./install.sh $(HOST_RUST_BIN_INSTALL_OPTS))
endef
endif

define HOST_RUST_BIN_INSTALL_CMDS
	$(HOST_RUST_BIN_INSTALL_RUSTC)
	$(HOST_RUST_BIN_INSTALL_LIBSTD_HOST)
	$(HOST_RUST_BIN_INSTALL_LIBSTD_TARGET)
endef

$(eval $(host-generic-package))
