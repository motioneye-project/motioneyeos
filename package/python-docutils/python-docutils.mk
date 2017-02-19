#############################################################
#
# python-docutils
#
#############################################################

PYTHON_DOCUTILS_VERSION = 0.12
PYTHON_DOCUTILS_SOURCE = docutils-$(PYTHON_DOCUTILS_VERSION).tar.gz
PYTHON_DOCUTILS_SITE = https://pypi.python.org/packages/37/38/ceda70135b9144d84884ae2fc5886c6baac4edea39550f28bcd144c1234d
PYTHON_DOCUTILS_LICENSE = Public Domain, BSD-2c, GPLv3 (emacs mode), other
PYTHON_DOCUTILS_LICENSE_FILES = COPYING.txt
PYTHON_DOCUTILS_SETUP_TYPE = distutils

$(eval $(python-package))
$(eval $(host-python-package))
