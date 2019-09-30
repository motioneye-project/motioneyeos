################################################################################
#
# python-urllib3
#
################################################################################

PYTHON_URLLIB3_VERSION = 1.25.6
PYTHON_URLLIB3_SOURCE = urllib3-$(PYTHON_URLLIB3_VERSION).tar.gz
PYTHON_URLLIB3_SITE = https://files.pythonhosted.org/packages/ff/44/29655168da441dff66de03952880c6e2d17b252836ff1aa4421fba556424
PYTHON_URLLIB3_LICENSE = MIT
PYTHON_URLLIB3_LICENSE_FILES = LICENSE.txt
PYTHON_URLLIB3_SETUP_TYPE = setuptools

$(eval $(python-package))
