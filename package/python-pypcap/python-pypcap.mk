################################################################################
#
# python-pypcap
#
################################################################################

PYTHON_PYPCAP_VERSION = 102
PYTHON_PYPCAP_SITE = https://pypcap.googlecode.com/svn/trunk
PYTHON_PYPCAP_SITE_METHOD = svn
PYTHON_PYPCAP_LICENSE = BSD-3c
PYTHON_PYPCAP_LICENSE_FILES = LICENSE
PYTHON_PYPCAP_SETUP_TYPE = distutils
PYTHON_PYPCAP_DEPENDENCIES = host-python-pyrex libpcap

define PYTHON_PYPCAP_CONFIGURE_CMDS
	$(HOST_DIR)/usr/bin/pyrexc $(@D)/pcap.pyx
	(cd $(@D); \
		$(HOST_DIR)/usr/bin/python setup.py \
		config --with-pcap=$(STAGING_DIR)/usr)
endef

$(eval $(python-package))
