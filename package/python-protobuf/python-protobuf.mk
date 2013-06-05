################################################################################
#
# python-protobuf
#
################################################################################

PYTHON_PROTOBUF_VERSION = $(PROTOBUF_VERSION)
PYTHON_PROTOBUF_SOURCE  = $(PROTOBUF_SOURCE)
PYTHON_PROTOBUF_SITE    = $(PROTOBUF_SITE)
PYTHON_PROTOBUF_LICENSE = BSD-3c
PYTHON_PROTOBUF_LICENSE_FILES = COPYING.txt

PYTHON_PROTOBUF_DEPENDENCIES = python host-python-setuptools \
        host-python-distutilscross host-protobuf

define PYTHON_PROTOBUF_BUILD_CMDS
	(cd $(@D)/python; \
		PYTHONXCPREFIX="$(STAGING_DIR)/usr/" \
		PATH=$(HOST_PATH) \
	$(HOST_DIR)/usr/bin/python setup.py build -x)
endef

define PYTHON_PROTOBUF_INSTALL_TARGET_CMDS
	(cd $(@D)/python; PYTHONPATH=$(TARGET_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages \
	$(HOST_DIR)/usr/bin/python setup.py install --prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
