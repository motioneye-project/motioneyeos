################################################################################
#
# python-id3
#
################################################################################

PYTHON_ID3_VERSION = 1.2
PYTHON_ID3_SOURCE = id3-py_$(PYTHON_ID3_VERSION).tar.gz
PYTHON_ID3_SITE = http://downloads.sourceforge.net/project/id3-py/id3-py/$(PYTHON_ID3_VERSION)
PYTHON_ID3_SETUP_TYPE = distutils

$(eval $(python-package))
