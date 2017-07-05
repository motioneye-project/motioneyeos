################################################################################
#
# python-pypcap
#
################################################################################

PYTHON_PYPCAP_VERSION = 6f46e7bf29a648256ddc732a7d0ec83d3ffca390
PYTHON_PYPCAP_SITE = $(call github,dugsong,pypcap,$(PYTHON_PYPCAP_VERSION))
PYTHON_PYPCAP_LICENSE = BSD-3-Clause
PYTHON_PYPCAP_LICENSE_FILES = LICENSE
PYTHON_PYPCAP_SETUP_TYPE = distutils
PYTHON_PYPCAP_DEPENDENCIES = host-python-pyrex libpcap

define PYTHON_PYPCAP_CONFIGURE_CMDS
	$(HOST_DIR)/bin/python2 $(HOST_DIR)/bin/pyrexc $(@D)/pcap.pyx
	(cd $(@D); \
		$(HOST_DIR)/bin/python setup.py \
		config --with-pcap=$(STAGING_DIR)/usr)
endef

$(eval $(python-package))
