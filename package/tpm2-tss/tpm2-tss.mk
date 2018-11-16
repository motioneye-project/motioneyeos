################################################################################
#
# tpm2-tss
#
################################################################################

TPM2_TSS_VERSION = 2.1.0
TPM2_TSS_SITE = https://github.com/tpm2-software/tpm2-tss/releases/download/$(TPM2_TSS_VERSION)
TPM2_TSS_LICENSE = BSD-2-Clause
TPM2_TSS_LICENSE_FILES = LICENSE
TPM2_TSS_INSTALL_STAGING = YES
TPM2_TSS_DEPENDENCIES = liburiparser openssl host-pkgconf
TPM2_TSS_CONF_OPTS = --with-crypto=ossl --disable-doxygen-doc

$(eval $(autotools-package))
