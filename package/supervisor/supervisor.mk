################################################################################
#
# supervisor
#
################################################################################

SUPERVISOR_VERSION = 3.0a12
SUPERVISOR_SOURCE = supervisor-$(SUPERVISOR_VERSION).tar.gz
SUPERVISOR_SITE = http://pypi.python.org/packages/source/s/supervisor/
SUPERVISOR_LICENSE_FILES = LICENSES.txt

SUPERVISOR_DEPENDENCIES = python host-python-setuptools

define SUPERVISOR_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define SUPERVISOR_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=/usr --root=$(TARGET_DIR))
	sed -i '1s|#!.*python.*|#!/usr/bin/env python|' $(TARGET_DIR)/usr/bin/{echo_supervisord_conf,pidproxy,supervisorctl,supervisord}
	$(INSTALL) -d -m 755 $(TARGET_DIR)/etc/supervisor.d
	$(INSTALL) -D -m 644 package/supervisor/supervisord.conf $(TARGET_DIR)/etc/supervisord.conf
	$(INSTALL) -m 755 package/supervisor/S99supervisord $(TARGET_DIR)/etc/init.d/S99supervisord
endef

$(eval $(generic-package))
