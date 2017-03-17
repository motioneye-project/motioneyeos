################################################################################
#
# tpm-tools
#
################################################################################

TPM_TOOLS_VERSION = 1.3.8
TPM_TOOLS_SITE = http://downloads.sourceforge.net/project/trousers/tpm-tools/$(TPM_TOOLS_VERSION)
TPM_TOOLS_STRIP_COMPONENTS = 2
TPM_TOOLS_LICENSE = Common Public License Version 1.0
TPM_TOOLS_LICENSE_FILES = LICENSE
TPM_TOOLS_DEPENDENCIES = trousers openssl \
	$(if $(BR2_NEEDS_GETTEXT_IF_LOCALE),gettext)
# configure.in and lib/Makefile.am is patched
TPM_TOOLS_AUTORECONF = YES
TPM_TOOLS_GETTEXTIZE = YES

TPM_TOOLS_CONF_OPTS = --disable-pkcs11-support

ifeq ($(BR2_PACKAGE_LIBICONV),y)
TPM_TOOLS_CONF_ENV += LIBS='-liconv'
endif

$(eval $(autotools-package))
