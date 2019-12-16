################################################################################
#
# supervisor
#
################################################################################

SUPERVISOR_VERSION = 4.1.0
SUPERVISOR_SITE = https://files.pythonhosted.org/packages/de/87/ee1ad8fa533a4b5f2c7623f4a2b585d3c1947af7bed8e65bc7772274320e
SUPERVISOR_LICENSE = BSD-like, rdflib (http_client.py), PSF (medusa)
SUPERVISOR_LICENSE_FILES = COPYRIGHT.txt LICENSES.txt
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

define SUPERVISOR_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 644 package/supervisor/supervisord.service \
		$(TARGET_DIR)/usr/lib/systemd/system/supervisord.service
endef

$(eval $(python-package))
