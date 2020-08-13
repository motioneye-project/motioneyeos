################################################################################
#
# python-aiomonitor
#
################################################################################

PYTHON_AIOMONITOR_VERSION = 0.4.5
PYTHON_AIOMONITOR_SOURCE = aiomonitor-$(PYTHON_AIOMONITOR_VERSION).tar.gz
PYTHON_AIOMONITOR_SITE = https://files.pythonhosted.org/packages/98/76/b62e9fbe267287527fb6f4b6774394d4f00650195774173bb0055a99ab3d
PYTHON_AIOMONITOR_SETUP_TYPE = setuptools
PYTHON_AIOMONITOR_LICENSE = Apache-2.0
PYTHON_AIOMONITOR_LICENSE_FILES = LICENSE

$(eval $(python-package))
