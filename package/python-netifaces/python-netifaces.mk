#############################################################
#
# python-netifaces
#
#############################################################

PYTHON_NETIFACES_VERSION = 0.7
PYTHON_NETIFACES_SOURCE  = netifaces-$(PYTHON_NETIFACES_VERSION).tar.gz
PYTHON_NETIFACES_SITE    = http://alastairs-place.net/projects/netifaces

PYTHON_NETIFACES_DEPENDENCIES = python host-python-setuptools host-python-distutilscross

define PYTHON_NETIFACES_BUILD_CMDS
	(cd $(@D); \
		PYTHONXCPREFIX="$(STAGING_DIR)/usr/" \
		LDFLAGS="-L$(STAGING_DIR)/lib -L$(STAGING_DIR)/usr/lib" \
	$(HOST_DIR)/usr/bin/python setup.py build -x)
endef

define PYTHON_NETIFACES_INSTALL_TARGET_CMDS
	(cd $(@D); PYTHONPATH=$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages \
	$(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
