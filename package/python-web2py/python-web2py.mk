################################################################################
#
# python-web2py
#
################################################################################

PYTHON_WEB2PY_VERSION = R-2.11.2
PYTHON_WEB2PY_SITE = $(call github,web2py,web2py,$(PYTHON_WEB2PY_VERSION))
PYTHON_WEB2PY_LICENSE = LGPLv3
PYTHON_WEB2PY_LICENSE_FILES = LICENSE
PYTHON_WEB2PY_DEPENDENCIES = python python-pydal host-python-pydal

define PYTHON_WEB2PY_INSTALL_TARGET_CMDS
	$(HOST_DIR)/usr/bin/python2 -c 'import os; \
		os.chdir("$(@D)"); \
		from gluon.main import save_password; \
		save_password($(BR2_PACKAGE_PYTHON_WEB2PY_PASSWORD),8000)'
	mkdir -p $(TARGET_DIR)/var/www/web2py
	cp -dpfr $(@D)/* $(TARGET_DIR)/var/www/web2py
endef

define PYTHON_WEB2PY_INSTALL_INIT_SYSV
	$(INSTALL) -m 0755 -D package/python-web2py/S51web2py \
		$(TARGET_DIR)/etc/init.d/S51web2py
endef

define PYTHON_WEB2PY_INSTALL_INIT_SYSTEMD
	$(INSTALL) -D -m 0644 package/python-web2py/web2py.service \
		$(TARGET_DIR)/usr/lib/systemd/system/web2py.service
	mkdir -p $(TARGET_DIR)/etc/systemd/system/multi-user.target.wants
	ln -fs ../../../../usr/lib//systemd/system/web2py.service \
		$(TARGET_DIR)/etc/systemd/system/multi-user.target.wants/web2py.service
endef

define PYTHON_WEB2PY_PERMISSIONS
	/var/www/web2py  r  750  www-data  www-data  -  -  -  -  -
endef

$(eval $(generic-package))
