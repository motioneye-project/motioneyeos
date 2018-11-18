################################################################################
#
# tpm2-tss
#
################################################################################

TPM2_TSS_VERSION = 1.4.0
TPM2_TSS_SITE = https://github.com/tpm2-software/tpm2-tss/releases/download/$(TPM2_TSS_VERSION)
TPM2_TSS_LICENSE = BSD-2-Clause
TPM2_TSS_LICENSE_FILES = LICENSE
TPM2_TSS_INSTALL_STAGING = YES
TPM2_TSS_DEPENDENCIES = liburiparser host-pkgconf

# configure.ac doesn't contain a link test, so it doesn't detect when
# libssp is missing.
TPM2_TSS_CONF_ENV = ax_cv_check_cflags___________Wall__Werror_______fstack_protector_all=$(if $(BR2_TOOLCHAIN_HAS_SSP),yes,no)

$(eval $(autotools-package))
