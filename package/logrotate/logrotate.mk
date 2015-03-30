################################################################################
#
# logrotate
#
################################################################################

LOGROTATE_VERSION = 3.8.9
LOGROTATE_SITE = https://www.fedorahosted.org/releases/l/o/logrotate
LOGROTATE_LICENSE = GPLv2+
LOGROTATE_LICENSE_FILES = COPYING
LOGROTATE_DEPENDENCIES = popt host-pkgconf
# tarball does not have a generated configure script
LOGROTATE_AUTORECONF = YES
LOGROTATE_CONF_ENV = LIBS="$(shell $(PKG_CONFIG_HOST_BINARY) --libs popt)"
LOGROTATE_CONF_OPTS = --without-selinux

ifeq ($(BR2_PACKAGE_ACL),y)
LOGROTATE_DEPENDENCIES += acl
LOGROTATE_CONF_OPTS += --with-acl
else
LOGROTATE_CONF_OPTS += --without-acl
endif

define LOGROTATE_INSTALL_TARGET_CONF
	$(INSTALL) -m 0644 package/logrotate/logrotate.conf $(TARGET_DIR)/etc/logrotate.conf
	$(INSTALL) -d -m 0755 $(TARGET_DIR)/etc/logrotate.d
endef
LOGROTATE_POST_INSTALL_TARGET_HOOKS += LOGROTATE_INSTALL_TARGET_CONF

$(eval $(autotools-package))
