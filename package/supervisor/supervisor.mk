################################################################################
#
# supervisor
#
################################################################################

SUPERVISOR_VERSION = 3.0a12
SUPERVISOR_SITE = http://pypi.python.org/packages/source/s/supervisor/
SUPERVISOR_LICENSE_FILES = LICENSES.txt
SUPERVISOR_SETUP_TYPE = setuptools

define SUPERVISOR_INSTALL_CONF_FILES
	$(INSTALL) -d -m 755 $(TARGET_DIR)/etc/supervisor.d
	$(INSTALL) -D -m 644 package/supervisor/supervisord.conf \
		$(TARGET_DIR)/etc/supervisord.conf
endef

SUPERVISOR_POST_INSTALL_TARGET_HOOKS += SUPERVISOR_INSTALL_CONF_FILES

define SUPERVISOR_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 755 package/supervisor/S99supervisord \
		$(TARGET_DIR)/etc/init.d/S99supervisord
endef

$(eval $(python-package))
