################################################################################
#
# python-pyjwt
#
################################################################################

PYTHON_PYJWT_VERSION = 1.6.4
PYTHON_PYJWT_SOURCE = PyJWT-$(PYTHON_PYJWT_VERSION).tar.gz
PYTHON_PYJWT_SITE = https://files.pythonhosted.org/packages/00/5e/b358c9bb24421e6155799d995b4aa3aa3307ffc7ecae4ad9d29fd7e07a73
PYTHON_PYJWT_LICENSE = MIT
PYTHON_PYJWT_SETUP_TYPE = setuptools

$(eval $(python-package))

