################################################################################
#
# python-arrow
#
################################################################################

PYTHON_ARROW_VERSION = 0.10.0
PYTHON_ARROW_SOURCE = arrow-$(PYTHON_ARROW_VERSION).tar.gz
PYTHON_ARROW_SITE = https://pypi.python.org/packages/54/db/76459c4dd3561bbe682619a5c576ff30c42e37c2e01900ed30a501957150
PYTHON_ARROW_SETUP_TYPE = setuptools
PYTHON_ARROW_LICENSE = Apache-2.0
PYTHON_ARROW_LICENSE_FILES = LICENSE docs/_themes/COPYING.txt

$(eval $(python-package))
