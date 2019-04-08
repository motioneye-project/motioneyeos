################################################################################
#
# tpm2-totp
#
################################################################################

TPM2_TOTP_VERSION = 0.1.1
TPM2_TOTP_SITE = https://github.com/tpm2-software/tpm2-totp/releases/download/v$(TPM2_TOTP_VERSION)
TPM2_TOTP_LICENSE = BSD-3-Clause
TPM2_TOTP_LICENSE_FILES = LICENSE
TPM2_TOTP_DEPENDENCIES = libqrencode tpm2-tss host-pkgconf

# -fstack-protector-all is used by default. Disable that so the BR2_SSP_* options
# in the toolchain wrapper and CFLAGS are used instead
TPM2_TOTP_CONF_ENV += \
	ax_cv_check_cflags___________Wall__Werror_______fstack_protector_all=no

# do not build man pages
TPM2_TOTP_CONF_ENV += ac_cv_path_PANDOC=''

$(eval $(autotools-package))
