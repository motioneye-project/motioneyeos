################################################################################
#
# libkrb5
#
################################################################################

LIBKRB5_VERSION_MAJOR = 1.18
LIBKRB5_VERSION = $(LIBKRB5_VERSION_MAJOR).1
LIBKRB5_SITE = https://web.mit.edu/kerberos/dist/krb5/$(LIBKRB5_VERSION_MAJOR)
LIBKRB5_SOURCE = krb5-$(LIBKRB5_VERSION).tar.gz
LIBKRB5_SUBDIR = src
LIBKRB5_LICENSE = MIT
LIBKRB5_LICENSE_FILES = NOTICE
LIBKRB5_DEPENDENCIES = host-bison $(TARGET_NLS_DEPENDENCIES)
LIBKRB5_INSTALL_STAGING = YES

# The configure script uses AC_TRY_RUN tests to check for those values,
# which doesn't work in a cross-compilation scenario. Therefore,
# we feed the configure script with the correct answer for those tests
LIBKRB5_CONF_ENV = \
	ac_cv_printf_positional=yes \
	ac_cv_func_regcomp=yes \
	krb5_cv_attr_constructor_destructor=yes,yes \
	LIBS=$(TARGET_NLS_LIBS)

# Never use the host packages
LIBKRB5_CONF_OPTS = \
	--without-system-db \
	--without-system-et \
	--without-system-ss \
	--without-system-verto \
	--without-tcl \
	--disable-rpath

ifeq ($(BR2_PACKAGE_OPENLDAP),y)
LIBKRB5_CONF_OPTS += --with-ldap
LIBKRB5_DEPENDENCIES += openldap
else
LIBKRB5_CONF_OPTS += --without-ldap
endif

ifeq ($(BR2_PACKAGE_LIBEDIT),y)
LIBKRB5_CONF_OPTS += --with-libedit
LIBKRB5_DEPENDENCIES += host-pkgconf libedit
else
LIBKRB5_CONF_OPTS += --without-libedit
endif

ifeq ($(BR2_PACKAGE_READLINE),y)
LIBKRB5_CONF_OPTS += --with-readline
LIBKRB5_DEPENDENCIES += readline
else
LIBKRB5_CONF_OPTS += --without-readline
endif

ifneq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
LIBKRB5_CONF_OPTS += --disable-thread-support
endif

$(eval $(autotools-package))
