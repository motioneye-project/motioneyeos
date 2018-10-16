################################################################################
#
# python-markdown2
#
################################################################################

PYTHON_MARKDOWN2_VERSION = 2.3.6
PYTHON_MARKDOWN2_SITE = $(call github,trentm,python-markdown2,$(PYTHON_MARKDOWN2_VERSION))
PYTHON_MARKDOWN2_SETUP_TYPE = distutils
PYTHON_MARKDOWN2_LICENSE = MIT
PYTHON_MARKDOWN2_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
