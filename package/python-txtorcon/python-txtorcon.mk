################################################################################
#
# python-txtorcon
#
################################################################################

PYTHON_TXTORCON_VERSION = 18.3.0
PYTHON_TXTORCON_SOURCE = txtorcon-$(PYTHON_TXTORCON_VERSION).tar.gz
PYTHON_TXTORCON_SITE = https://files.pythonhosted.org/packages/a2/71/2fe0c7d9350ff95cd22128f375dbf2b49438ca1a5d8ca0795311a964586b
PYTHON_TXTORCON_SETUP_TYPE = setuptools
PYTHON_TXTORCON_LICENSE = MIT
PYTHON_TXTORCON_LICENSE_FILES = LICENSE

$(eval $(python-package))
