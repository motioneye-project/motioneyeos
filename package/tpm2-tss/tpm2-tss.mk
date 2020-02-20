################################################################################
#
# tpm2-tss
#
################################################################################

TPM2_TSS_VERSION = 2.3.3
TPM2_TSS_SITE = https://github.com/tpm2-software/tpm2-tss/releases/download/$(TPM2_TSS_VERSION)
TPM2_TSS_LICENSE = BSD-2-Clause
TPM2_TSS_LICENSE_FILES = LICENSE
TPM2_TSS_INSTALL_STAGING = YES
TPM2_TSS_DEPENDENCIES = liburiparser openssl host-pkgconf
TPM2_TSS_CONF_OPTS = --with-crypto=ossl --disable-doxygen-doc --disable-defaultflags
# 0001-configure-Only-use-CXX-when-fuzzing.patch
TPM2_TSS_AUTORECONF = YES

# uses C99 code but forgets to pass -std=c99 when --disable-defaultflags is used
TPM2_TSS_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -std=c99"

# The 2.3.3 tarball accidently contains a Makefile-fuzz-generated.am
# with content from a fuzz testing run rather than an empty file,
# confusing autoreconf with
# 0001-configure-Only-use-CXX-when-fuzzing.patch
define TPM2_TSS_TRUNCATE_MAKEFILE_FUZZ_GENERATED_AM
	truncate -s 0 $(@D)/Makefile-fuzz-generated.am
endef
TPM2_TSS_POST_PATCH_HOOKS += TPM2_TSS_TRUNCATE_MAKEFILE_FUZZ_GENERATED_AM

$(eval $(autotools-package))
