################################################################################
#
# cargo
#
################################################################################

CARGO_VERSION = 0.26.0
CARGO_SITE = $(call github,rust-lang,cargo,$(CARGO_VERSION))
CARGO_LICENSE = Apache-2.0 or MIT
CARGO_LICENSE_FILES = LICENSE-APACHE LICENSE-MIT

CARGO_DEPS_SHA512 = 6ed2a1644c9b18fc24ddad5350d41b6c36cd5b62de4cf0b748a57b589f4f0ac12f91461989158d58d0892bf6fc2c1626cf574e7e2b9da4b0e35f72dfd88f9048
CARGO_DEPS_SITE = https://src.fedoraproject.org/repo/pkgs/cargo/$(CARGO_DEPS_SOURCE)/sha512/$(CARGO_DEPS_SHA512)
CARGO_DEPS_SOURCE = cargo-$(CARGO_VERSION)-vendor.tar.xz

CARGO_INSTALLER_VERSION = 4f994850808a572e2cc8d43f968893c8e942e9bf
CARGO_INSTALLER_SITE = $(call github,rust-lang,rust-installer,$(CARGO_INSTALLER_VERSION))
CARGO_INSTALLER_SOURCE = rust-installer-$(CARGO_INSTALLER_VERSION).tar.gz

HOST_CARGO_EXTRA_DOWNLOADS = \
	$(CARGO_DEPS_SITE)/$(CARGO_DEPS_SOURCE) \
	$(CARGO_INSTALLER_SITE)/$(CARGO_INSTALLER_SOURCE)

HOST_CARGO_DEPENDENCIES = \
	$(BR2_CMAKE_HOST_DEPENDENCY) \
	host-pkgconf \
	host-openssl \
	host-libhttpparser \
	host-libssh2 \
	host-libcurl \
	host-rustc \
	host-cargo-bin

HOST_CARGO_SNAP_BIN = $(HOST_CARGO_BIN_DIR)/cargo/bin/cargo
HOST_CARGO_HOME = $(HOST_DIR)/share/cargo

define HOST_CARGO_EXTRACT_DEPS
	@mkdir -p $(@D)/vendor
	$(call suitable-extractor,$(CARGO_DEPS_SOURCE)) \
		$(HOST_CARGO_DL_DIR)/$(CARGO_DEPS_SOURCE) | \
		$(TAR) --strip-components=1 -C $(@D)/vendor $(TAR_OPTIONS) -
endef

HOST_CARGO_POST_EXTRACT_HOOKS += HOST_CARGO_EXTRACT_DEPS

define HOST_CARGO_EXTRACT_INSTALLER
	@mkdir -p $(@D)/src/rust-installer
	$(call suitable-extractor,$(CARGO_INSTALLER_SOURCE)) \
		$(HOST_CARGO_DL_DIR)/$(CARGO_INSTALLER_SOURCE) | \
		$(TAR) --strip-components=1 -C $(@D)/src/rust-installer $(TAR_OPTIONS) -
endef

HOST_CARGO_POST_EXTRACT_HOOKS += HOST_CARGO_EXTRACT_INSTALLER

define HOST_CARGO_SETUP_DEPS
	mkdir -p $(@D)/.cargo
	( \
		echo "[source.crates-io]"; \
		echo "registry = 'https://github.com/rust-lang/crates.io-index'"; \
		echo "replace-with = 'vendored-sources'"; \
		echo "[source.vendored-sources]"; \
		echo "directory = '$(@D)/vendor'"; \
	) > $(@D)/.cargo/config
endef

HOST_CARGO_PRE_CONFIGURE_HOOKS += HOST_CARGO_SETUP_DEPS

HOST_CARGO_SNAP_OPTS = \
	--release \
	$(if $(VERBOSE),--verbose)

HOST_CARGO_ENV = \
	RUSTFLAGS="$(addprefix -Clink-arg=,$(HOST_LDFLAGS))" \
	CARGO_HOME=$(HOST_CARGO_HOME)

define HOST_CARGO_BUILD_CMDS
	(cd $(@D); $(HOST_MAKE_ENV) $(HOST_CARGO_ENV) $(HOST_CARGO_SNAP_BIN) \
		build $(HOST_CARGO_SNAP_OPTS))
endef

define HOST_CARGO_INSTALL_CMDS
	$(INSTALL) -D -m 0755 $(@D)/target/release/cargo $(HOST_DIR)/bin/cargo
	$(INSTALL) -D package/cargo/config.in \
		$(HOST_DIR)/share/cargo/config
	$(SED) 's/@RUSTC_TARGET_NAME@/$(RUSTC_TARGET_NAME)/' \
		$(HOST_DIR)/share/cargo/config
	$(SED) 's/@CROSS_PREFIX@/$(notdir $(TARGET_CROSS))/' \
		$(HOST_DIR)/share/cargo/config
endef

$(eval $(host-generic-package))
