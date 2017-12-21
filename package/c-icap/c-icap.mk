################################################################################
#
# c-icap
#
################################################################################

C_ICAP_VERSION = 0.4.2
C_ICAP_SOURCE = c_icap-$(C_ICAP_VERSION).tar.gz
C_ICAP_SITE = http://downloads.sourceforge.net/c-icap
C_ICAP_LICENSE = LGPL-2.1+
C_ICAP_LICENSE_FILES = COPYING
C_ICAP_INSTALL_STAGING = YES
C_ICAP_CONFIG_SCRIPTS = c-icap-config c-icap-libicapapi-config
C_ICAP_CONF_OPTS = \
	--without-perl \
	--enable-large-files \
	--enable-ipv6
# Pre-seed cache variables for tests done with AC_TRY_RUN that are not
# cross-compile friendly
C_ICAP_CONF_ENV = ac_cv_10031b_ipc_sem=yes ac_cv_fcntl=yes
# c-icap adds '-Wl,-rpath -Wl,/usr/lib' to the link command line. This
# causes the linker to search for libraries that are listed as NEEDED
# in the libicapapi.so ELF header in host libraries, which breaks the
# build. The affected library is libz. Forcing AUTORECONF adds -lz to
# the link command line, and that makes the linker look first in
# sysroot, thus avoiding the build breakage.
C_ICAP_AUTORECONF = YES

ifeq ($(BR2_PACKAGE_BERKELEYDB),y)
C_ICAP_CONF_OPTS += --with-bdb
C_ICAP_DEPENDENCIES += berkeleydb
else
C_ICAP_CONF_OPTS += --without-bdb
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
C_ICAP_CONF_OPTS += --with-bzlib
C_ICAP_DEPENDENCIES += bzip2
else
C_ICAP_CONF_OPTS += --without-bzlib
endif

ifeq ($(BR2_PACKAGE_LIBMEMCACHED),y)
C_ICAP_CONF_OPTS += --with-memcached
C_ICAP_DEPENDENCIES += libmemcached
else
C_ICAP_CONF_OPTS += --without-memcached
endif

ifeq ($(BR2_PACKAGE_OPENLDAP),y)
C_ICAP_CONF_OPTS += --with-ldap
C_ICAP_DEPENDENCIES += openldap
else
C_ICAP_CONF_OPTS += --without-ldap
endif

ifeq ($(BR2_PACKAGE_OPENSSL),y)
C_ICAP_CONF_OPTS += --with-openssl
C_ICAP_DEPENDENCIES += openssl
else
C_ICAP_CONF_OPTS += --without-openssl
endif

ifeq ($(BR2_PACKAGE_PCRE),y)
C_ICAP_CONF_OPTS += --with-pcre
C_ICAP_DEPENDENCIES += pcre
else
C_ICAP_CONF_OPTS += --without-pcre
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
C_ICAP_CONF_OPTS += --with-zlib
C_ICAP_DEPENDENCIES += zlib
else
C_ICAP_CONF_OPTS += --without-zlib
endif

define C_ICAP_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/c-icap/S96cicap $(TARGET_DIR)/etc/init.d/S96cicap
endef

# Tweak the installation:
#  - Removed unneeded sample configuration files (c-icap.*.default),
#    since some real ones are also installed
#  - Tweak some paths in the c-icap.conf configuration file
#  - Tweak the -config scripts, because the generic
#    <pkg>_CONFIG_SCRIPTS logic doesn't tweak them enough
define C_ICAP_TUNE_INSTALLATION
	$(RM) -f $(TARGET_DIR)/etc/c-icap.*.default
	$(SED) 's%/usr/etc/%/etc/%' $(TARGET_DIR)/etc/c-icap.conf
	$(SED) 's%/usr/var/%/var/%' $(TARGET_DIR)/etc/c-icap.conf
	$(SED) 's%INCDIR=.*%INCDIR=$(STAGING_DIR)/usr/include%' \
		$(STAGING_DIR)/usr/bin/{c-icap,c-icap-libicapapi}-config
	$(SED) 's%INCDIR2=.*%INCDIR2=$(STAGING_DIR)/usr/include/c_icap%' \
		$(STAGING_DIR)/usr/bin/{c-icap,c-icap-libicapapi}-config
	$(SED) 's%-L$$LIBDIR %%' $(STAGING_DIR)/usr/bin/c-icap-libicapapi-config
endef

C_ICAP_POST_INSTALL_TARGET_HOOKS += C_ICAP_TUNE_INSTALLATION

$(eval $(autotools-package))
