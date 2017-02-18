################################################################################
#
# python-dicttoxml
#
################################################################################

PYTHON_DICTTOXML_VERSION = 1.7.4
PYTHON_DICTTOXML_SOURCE = dicttoxml-$(PYTHON_DICTTOXML_VERSION).tar.gz
PYTHON_DICTTOXML_SITE = https://pypi.python.org/packages/74/36/534db111db9e7610a41641a1f6669a964aacaf51858f466de264cc8dcdd9
PYTHON_DICTTOXML_SETUP_TYPE = distutils
PYTHON_DICTTOXML_LICENSE = GPLv2
PYTHON_DICTTOXML_LICENSE_FILES = LICENCE.txt

$(eval $(python-package))
