################################################################################
#
# python-web2py
#
################################################################################

PYTHON_WEB2PY_VERSION = R-2.17.2
PYTHON_WEB2PY_SITE = $(call github,web2py,web2py,$(PYTHON_WEB2PY_VERSION))
PYTHON_WEB2PY_LICENSE = LGPL-3.0
PYTHON_WEB2PY_LICENSE_FILES = LICENSE
PYTHON_WEB2PY_DEPENDENCIES = $(if $(BR2_PACKAGE_PYTHON3),host-python3 python3,host-python python) \
	python-pydal host-python-pydal

PYTHON_WEB2PY_EXCLUSIONS = \
	welcome.w2p \
	applications/examples \
	applications/welcome \
	deposit \
	docs \
	examples \
	extras \
	handlers \
	scripts \
	ABOUT \
	anyserver.py \
	CHANGELOG \
	Makefile \
	MANIFEST.in \
	README.markdown \
	setup.py \
	tox.ini

define PYTHON_WEB2PY_GENERATE_PASSWORD
	$(HOST_DIR)/bin/python -c 'import os; \
		os.chdir("$(@D)"); \
		from gluon.main import save_password; \
		save_password($(BR2_PACKAGE_PYTHON_WEB2PY_PASSWORD),8000)'
endef

ifeq ($(BR2_PACKAGE_PYTHON_WEB2PY_INSTALL_ADMIN),y)
PYTHON_WEB2PY_POST_BUILD_HOOKS += PYTHON_WEB2PY_GENERATE_PASSWORD
else
PYTHON_WEB2PY_EXCLUSIONS += applications/admin
endif

define PYTHON_WEB2PY_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/var/www/web2py
	rsync -a $(@D)/ $(TARGET_DIR)/var/www/web2py/ \
		$(addprefix --exclude=,$(PYTHON_WEB2PY_EXCLUSIONS))
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

# www-data user and group are used for web2py. Because these user and group
# are already set by buildroot, it is not necessary to redefine them.
# See system/skeleton/etc/passwd
#   username: www-data    uid: 33
#   groupname: www-data   gid: 33
#
# So, we just need to create the directories used by web2py with the right
# ownership.
define PYTHON_WEB2PY_PERMISSIONS
	/var/www/web2py  r  750  33  33  -  -  -  -  -
endef

$(eval $(generic-package))
