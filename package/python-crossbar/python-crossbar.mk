################################################################################
#
# python-crossbar
#
################################################################################

PYTHON_CROSSBAR_VERSION = 20.2.1
PYTHON_CROSSBAR_SOURCE = crossbar-$(PYTHON_CROSSBAR_VERSION).tar.gz
PYTHON_CROSSBAR_SITE = https://files.pythonhosted.org/packages/78/f0/82970d84abd532bdea007322b73bfe2d7762194b85155296b76ba48724e9
PYTHON_CROSSBAR_LICENSE = AGPL-3.0
PYTHON_CROSSBAR_LICENSE_FILES = crossbar/LICENSE
PYTHON_CROSSBAR_SETUP_TYPE = setuptools

$(eval $(python-package))
