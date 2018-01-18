################################################################################
#
# python-txtorcon
#
################################################################################

PYTHON_TXTORCON_VERSION = 0.19.3
PYTHON_TXTORCON_SOURCE = txtorcon-$(PYTHON_TXTORCON_VERSION).tar.gz
PYTHON_TXTORCON_SITE = https://pypi.python.org/packages/05/4b/d2fbfdc08ab83c299f2ad22ba38ea35f71f1c966684f5754e079108a1f64
PYTHON_TXTORCON_SETUP_TYPE = setuptools
PYTHON_TXTORCON_LICENSE = MIT
PYTHON_TXTORCON_LICENSE_FILES = LICENSE

$(eval $(python-package))
