################################################################################
#
# c-icap
#
################################################################################

C_ICAP_VERSION = 0.3.5
C_ICAP_SOURCE = c_icap-$(C_ICAP_VERSION).tar.gz
C_ICAP_SITE = http://downloads.sourceforge.net/c-icap/
C_ICAP_LICENSE = LGPLv2.1+
C_ICAP_LICENSE_FILES = COPYING
C_ICAP_INSTALL_STAGING = YES
C_ICAP_CONFIG_SCRIPTS = c-icap-config c-icap-libicapapi-config
C_ICAP_CONF_OPTS = \
	--with-process-mutexes=posix \
	--without-ldap \
	--without-perl \
	--enable-large-files \
	--enable-ipv6

ifeq ($(BR2_PACKAGE_BERKELEYDB),y)
C_ICAP_CONF_OPTS += --with-berkeleydb
C_ICAP_DEPENDENCIES += berkeleydb
else
C_ICAP_CONF_OPTS += --without-berkeleydb
endif

ifeq ($(BR2_PACKAGE_BZIP2),y)
C_ICAP_CONF_OPTS += --with-bzip2
C_ICAP_DEPENDENCIES += bzip2
else
C_ICAP_CONF_OPTS += --without-bzip2
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
