################################################################################
#
# python-hyperlink
#
################################################################################

PYTHON_HYPERLINK_VERSION = 18.0.0
PYTHON_HYPERLINK_SOURCE = hyperlink-$(PYTHON_HYPERLINK_VERSION).tar.gz
PYTHON_HYPERLINK_SITE = https://files.pythonhosted.org/packages/41/e1/0abd4b480ec04892b1db714560f8c855d43df81895c98506442babf3652f
PYTHON_HYPERLINK_SETUP_TYPE = setuptools
PYTHON_HYPERLINK_LICENSE = MIT
PYTHON_HYPERLINK_LICENSE_FILES = LICENSE

$(eval $(python-package))
