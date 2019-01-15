################################################################################
#
# tpm2-tools
#
################################################################################

TPM2_TOOLS_VERSION = 3.1.3
TPM2_TOOLS_SITE = https://github.com/tpm2-software/tpm2-tools/releases/download/$(TPM2_TOOLS_VERSION)
TPM2_TOOLS_LICENSE = BSD-2-Clause
TPM2_TOOLS_LICENSE_FILES = LICENSE
TPM2_TOOLS_DEPENDENCIES = dbus libcurl libglib2 openssl tpm2-tss host-pkgconf

# -fstack-protector-all and FORTIFY_SOURCE=2 is used by
# default. Disable that so the BR2_SSP_* / BR2_FORTIFY_SOURCE_* options
# in the toolchain wrapper and CFLAGS are used instead
TPM2_TOOLS_CONF_OPTS = --disable-hardening

$(eval $(autotools-package))
