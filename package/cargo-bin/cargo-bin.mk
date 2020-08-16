################################################################################
#
# cargo-bin
#
################################################################################

CARGO_BIN_VERSION = 0.33.0
CARGO_BIN_SITE = https://static.rust-lang.org/dist
CARGO_BIN_SOURCE = cargo-$(CARGO_BIN_VERSION)-$(RUSTC_HOST_NAME).tar.xz
CARGO_BIN_LICENSE = Apache-2.0 or MIT
CARGO_BIN_LICENSE_FILES = LICENSE-APACHE LICENSE-MIT

$(eval $(host-generic-package))
