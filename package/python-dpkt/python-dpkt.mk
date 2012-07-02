#############################################################
#
# python-dpkt
#
#############################################################

PYTHON_DPKT_VERSION = 1.7
PYTHON_DPKT_SOURCE  = dpkt-$(PYTHON_DPKT_VERSION).tar.gz
PYTHON_DPKT_SITE    = http://dpkt.googlecode.com/files

PYTHON_DPKT_DEPENDENCIES = python

define PYTHON_DPKT_BUILD_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py build)
endef

define PYTHON_DPKT_INSTALL_TARGET_CMDS
	(cd $(@D); $(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))

