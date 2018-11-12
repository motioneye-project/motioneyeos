################################################################################
#
# tpm-tools
#
################################################################################

TPM_TOOLS_VERSION = 1.3.9.1
TPM_TOOLS_SITE = http://downloads.sourceforge.net/project/trousers/tpm-tools/$(TPM_TOOLS_VERSION)
TPM_TOOLS_LICENSE = Common Public License Version 1.0
TPM_TOOLS_LICENSE_FILES = LICENSE
TPM_TOOLS_DEPENDENCIES = trousers openssl $(TARGET_NLS_DEPENDENCIES)

TPM_TOOLS_CONF_OPTS = --disable-pkcs11-support

ifeq ($(BR2_PACKAGE_LIBICONV),y)
TPM_TOOLS_CONF_ENV += LIBS='-liconv'
endif

ifeq ($(BR2_arc770d)$(BR2_arc750d),y)
TPM_TOOLS_CONF_ENV += CFLAGS="$(TARGET_CFLAGS) -mno-compact-casesi"
endif

$(eval $(autotools-package))
