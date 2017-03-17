################################################################################
#
# python-dominate
#
################################################################################

PYTHON_DOMINATE_VERSION = 2.3.1
PYTHON_DOMINATE_SOURCE = dominate-$(PYTHON_DOMINATE_VERSION).tar.gz
PYTHON_DOMINATE_SITE = https://pypi.python.org/packages/43/b2/3b7d67dd59dab93ae08569384b254323516e8868b453eea5614a53835baf
PYTHON_DOMINATE_SETUP_TYPE = setuptools
PYTHON_DOMINATE_LICENSE = LGPLv3+
PYTHON_DOMINATE_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
