################################################################################
#
# python-rq
#
################################################################################

PYTHON_RQ_VERSION = 0.13.0
PYTHON_RQ_SOURCE = rq-$(PYTHON_RQ_VERSION).tar.gz
PYTHON_RQ_SITE = https://files.pythonhosted.org/packages/d2/d7/51904875025b2432cb3c97cc476ab8d2033a8f105393db2267622e56f3ac
PYTHON_RQ_SETUP_TYPE = setuptools
PYTHON_RQ_LICENSE = Apache-2.0
PYTHON_RQ_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
