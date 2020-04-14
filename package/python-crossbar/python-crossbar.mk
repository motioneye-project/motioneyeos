################################################################################
#
# python-crossbar
#
################################################################################

PYTHON_CROSSBAR_VERSION = 20.4.1
PYTHON_CROSSBAR_SOURCE = crossbar-$(PYTHON_CROSSBAR_VERSION).tar.gz
PYTHON_CROSSBAR_SITE = https://files.pythonhosted.org/packages/2c/0c/054ac48881390c83f8bee2a1b50cd5fa6322aa83f589090ced572079b974
PYTHON_CROSSBAR_LICENSE = AGPL-3.0
PYTHON_CROSSBAR_LICENSE_FILES = crossbar/LICENSE
PYTHON_CROSSBAR_SETUP_TYPE = setuptools

$(eval $(python-package))
