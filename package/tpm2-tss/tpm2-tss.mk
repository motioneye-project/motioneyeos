################################################################################
#
# tpm2-tss
#
################################################################################

TPM2_TSS_VERSION = 2.1.1
TPM2_TSS_SITE = https://github.com/tpm2-software/tpm2-tss/releases/download/$(TPM2_TSS_VERSION)
TPM2_TSS_LICENSE = BSD-2-Clause
TPM2_TSS_LICENSE_FILES = LICENSE
TPM2_TSS_INSTALL_STAGING = YES
TPM2_TSS_DEPENDENCIES = liburiparser openssl host-pkgconf
TPM2_TSS_CONF_OPTS = --with-crypto=ossl --disable-doxygen-doc

# -fstack-protector-all and FORTIFY_SOURCE=2 is used by
# default. Disable that so the BR2_SSP_* / BR2_FORTIFY_SOURCE_* options
# in the toolchain wrapper and CFLAGS are used instead
TPM2_TSS_CONF_ENV = \
	ax_cv_check_cflags___________Wall__Werror_______fstack_protector_all=no \
	ax_cv_check_ccppflags___________Wall__Werror_______U_FORTIFY_SOURCE=no \
	ax_cv_check_ccppflags___________Wall__Werror_______D_FORTIFY_SOURCE_2=no

$(eval $(autotools-package))
