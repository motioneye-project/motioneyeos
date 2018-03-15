################################################################################
#
# tpm2-tools
#
################################################################################

TPM2_TOOLS_VERSION = 3.0.3
TPM2_TOOLS_SITE = https://github.com/tpm2-software/tpm2-tools/releases/download/$(TPM2_TOOLS_VERSION)
TPM2_TOOLS_LICENSE = BSD-2-Clause
TPM2_TOOLS_LICENSE_FILES = LICENSE
TPM2_TOOLS_DEPENDENCIES = dbus libcurl libglib2 openssl tpm2-tss host-pkgconf

$(eval $(autotools-package))
