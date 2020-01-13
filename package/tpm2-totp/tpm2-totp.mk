################################################################################
#
# tpm2-totp
#
################################################################################

TPM2_TOTP_VERSION = 0.2.1
TPM2_TOTP_SITE = https://github.com/tpm2-software/tpm2-totp/releases/download/v$(TPM2_TOTP_VERSION)
TPM2_TOTP_LICENSE = BSD-3-Clause
TPM2_TOTP_LICENSE_FILES = LICENSE
TPM2_TOTP_DEPENDENCIES = libqrencode tpm2-tss host-pkgconf
TPM2_TOTP_CONF_OPTS = \
	--disable-defaultflags \
	--disable-doxygen-doc \
	--disable-plymouth \
	--without-initramfstoolsdir \
	--without-mkinitcpiodir

# uses C99 code but forgets to pass -std=c99 when --disable-defaultflags is used
TPM2_TOTP_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -std=c99"

# do not build man pages
TPM2_TOTP_CONF_ENV += ac_cv_path_PANDOC=''

$(eval $(autotools-package))
