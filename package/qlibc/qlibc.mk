################################################################################
#
# qlibc
#
################################################################################

QLIBC_VERSION = 2.4.4
QLIBC_SITE = $(call github,wolkykim,qlibc,v$(QLIBC_VERSION))
QLIBC_LICENSE = BSD-2-Clause
QLIBC_LICENSE_FILES = LICENSE

QLIBC_INSTALL_STAGING = YES
QLIBC_DEPENDENCIES = $(if $(BR2_PACKAGE_LIBICONV),libiconv)

# The configure.ac checks for these use AC_CHECK_FILE() which doesn't
# work for cross-compilation. If someone wants to enable the support
# for OpenSSL or MySQL, some changes to the configure.ac will be
# needed.
QLIBC_CONF_OPTS = --without-mysql --without-openssl

$(eval $(autotools-package))
