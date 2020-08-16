################################################################################
#
# python-ifaddr
#
################################################################################

PYTHON_IFADDR_VERSION = 0.1.6
PYTHON_IFADDR_SOURCE = ifaddr-$(PYTHON_IFADDR_VERSION).tar.gz
PYTHON_IFADDR_SITE = https://files.pythonhosted.org/packages/9f/54/d92bda685093ebc70e2057abfa83ef1b3fb0ae2b6357262a3e19dfe96bb8
PYTHON_IFADDR_SETUP_TYPE = setuptools
PYTHON_IFADDR_LICENSE = MIT
PYTHON_IFADDR_LICENSE_FILES = setup.py

$(eval $(python-package))
