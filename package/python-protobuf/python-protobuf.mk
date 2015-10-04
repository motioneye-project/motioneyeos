################################################################################
#
# python-protobuf
#
################################################################################

PYTHON_PROTOBUF_VERSION = $(PROTOBUF_VERSION)
PYTHON_PROTOBUF_SOURCE = $(PROTOBUF_SOURCE)
PYTHON_PROTOBUF_SITE = $(PROTOBUF_SITE)
PYTHON_PROTOBUF_LICENSE = BSD-3c
PYTHON_PROTOBUF_LICENSE_FILES = COPYING.txt
PYTHON_PROTOBUF_DEPENDENCIES = host-protobuf
PYTHON_PROTOBUF_SETUP_TYPE = setuptools
PYTHON_PROTOBUF_SUBDIR = python

$(eval $(python-package))
