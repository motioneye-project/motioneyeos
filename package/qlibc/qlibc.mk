################################################################################
#
# qlibc
#
################################################################################

QLIBC_VERSION = v2.1.6
QLIBC_SITE = $(call github,wolkykim,qlibc,$(QLIBC_VERSION))
QLIBC_LICENSE = BSD-2c
QLIBC_LICENSE_FILES = COPYING

# We're patching configure.ac
QLIBC_AUTORECONF = YES
QLIBC_INSTALL_STAGING = YES
QLIBC_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)

# The configure.ac checks for these use AC_CHECK_FILE() which doesn't
# work for cross-compilation. If someone wants to enable the support
# for OpenSSL or MySQL, some changes to the configure.ac will be
# needed.
QLIBC_CONF_OPTS = --without-mysql --without-openssl

$(eval $(autotools-package))
