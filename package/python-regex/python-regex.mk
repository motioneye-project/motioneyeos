################################################################################
#
# python-regex
#
################################################################################

# Please keep in sync with package/python3-regex/python3-regex.mk
PYTHON_REGEX_VERSION = 2020.2.20
PYTHON_REGEX_SOURCE = regex-$(PYTHON_REGEX_VERSION).tar.gz
PYTHON_REGEX_SITE = https://files.pythonhosted.org/packages/e8/76/8ac7f467617b9cfbafcef3c76df6f22b15de654a62bea719792b00a83195
PYTHON_REGEX_SETUP_TYPE = setuptools
PYTHON_REGEX_LICENSE = CNRI-Python

$(eval $(python-package))
