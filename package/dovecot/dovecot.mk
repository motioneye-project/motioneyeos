################################################################################
#
# dovecot
#
################################################################################

DOVECOT_VERSION_MAJOR = 2.2
DOVECOT_VERSION = $(DOVECOT_VERSION_MAJOR).15
DOVECOT_SITE = http://www.dovecot.org/releases/$(DOVECOT_VERSION_MAJOR)
DOVECOT_INSTALL_STAGING = YES
DOVECOT_LICENSE = LGPLv2.1
DOVECOT_LICENSE_FILES = COPYING COPYING.LGPL COPYING.MIT
DOVECOT_DEPENDENCIES = host-pkgconf $(if $(BR2_PACKAGE_LIBICONV),libiconv)

DOVECOT_CONF_ENV = \
	RPCGEN=__disable_RPCGEN_rquota \
	i_cv_epoll_works=yes \
	i_cv_inotify_works=yes \
	i_cv_posix_fallocate_works=no \
	i_cv_signed_size_t=no \
	i_cv_gmtime_max_time_t=32 \
	i_cv_signed_time_t=yes \
	i_cv_mmap_plays_with_write=yes \
	i_cv_fd_passing=yes \
	i_cv_c99_vsnprintf=yes \
	lib_cv_va_copy=yes \
	lib_cv___va_copy=yes \
	lib_cv_va_val_copy=yes

DOVECOT_CONF_OPTS = --without-docs

ifeq ($(BR2_PACKAGE_DOVECOT_MYSQL)$(BR2_PACKAGE_DOVECOT_SQLITE),)
DOVECOT_CONF_OPTS += --without-sql
endif

ifeq ($(BR2_PACKAGE_DOVECOT_BZIP2),y)
DOVECOT_CONF_OPTS += --with-bzlib
DOVECOT_DEPENDENCIES += bzip2
else
DOVECOT_CONF_OPTS += --without-bzlib
endif

ifeq ($(BR2_PACKAGE_LIBCAP),y)
DOVECOT_CONF_OPTS += --with-libcap
DOVECOT_DEPENDENCIES += libcap
else
DOVECOT_CONF_OPTS += --without-libcap
endif

ifeq ($(BR2_PACKAGE_DOVECOT_MYSQL),y)
DOVECOT_CONF_ENV += MYSQL_CONFIG="$(STAGING_DIR)/usr/bin/mysql_config"
DOVECOT_CONF_OPTS += --with-mysql
DOVECOT_DEPENDENCIES += mysql
else
DOVECOT_CONF_OPTS += --without-mysql
endif

ifeq ($(BR2_PACKAGE_DOVECOT_OPENSSL),y)
DOVECOT_CONF_OPTS += --with-ssl=openssl
DOVECOT_DEPENDENCIES += openssl
else
DOVECOT_CONF_OPTS += --with-ssl=no
endif

ifeq ($(BR2_PACKAGE_DOVECOT_SQLITE),y)
DOVECOT_CONF_OPTS += --with-sqlite
DOVECOT_DEPENDENCIES += sqlite
else
DOVECOT_CONF_OPTS += --without-sqlite
endif

ifeq ($(BR2_PACKAGE_DOVECOT_ZLIB),y)
DOVECOT_CONF_OPTS += --with-zlib
DOVECOT_DEPENDENCIES += zlib
else
DOVECOT_CONF_OPTS += --without-zlib
endif

# fix paths to avoid using /usr/lib/dovecot
define DOVECOT_POST_CONFIGURE
	for i in $$(find $(@D) -name "Makefile"); do \
		$(SED) 's%^pkglibdir =.*%pkglibdir = \$$(libdir)%' $$i; \
		$(SED) 's%^pkglibexecdir =.*%pkglibexecdir = \$$(libexecdir)%' $$i; \
	done
endef

DOVECOT_POST_CONFIGURE_HOOKS += DOVECOT_POST_CONFIGURE

# dovecot installs dovecot-config in usr/lib/, therefore
# DOVECOT_CONFIG_SCRIPTS can not be used to rewrite paths
define DOVECOT_FIX_STAGING_DOVECOT_CONFIG
	$(SED) 's,^LIBDOVECOT_INCLUDE=.*$$,LIBDOVECOT_INCLUDE=\"-I$(STAGING_DIR)/usr/include/dovecot\",' $(STAGING_DIR)/usr/lib/dovecot-config
	$(SED) 's,^LIBDOVECOT=.*$$,LIBDOVECOT=\"-L$(STAGING_DIR)/usr/lib -ldovecot\",' $(STAGING_DIR)/usr/lib/dovecot-config
endef

DOVECOT_POST_INSTALL_STAGING_HOOKS += DOVECOT_FIX_STAGING_DOVECOT_CONFIG

$(eval $(autotools-package))
