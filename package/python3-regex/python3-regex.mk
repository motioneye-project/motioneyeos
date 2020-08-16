################################################################################
#
# python3-regex
#
################################################################################

# Please keep in sync with package/python-regex/python-regex.mk
PYTHON3_REGEX_VERSION = 2020.2.20
PYTHON3_REGEX_SOURCE = regex-$(PYTHON3_REGEX_VERSION).tar.gz
PYTHON3_REGEX_SITE = https://files.pythonhosted.org/packages/e8/76/8ac7f467617b9cfbafcef3c76df6f22b15de654a62bea719792b00a83195
PYTHON3_REGEX_SETUP_TYPE = setuptools
PYTHON3_REGEX_LICENSE = CNRI-Python
HOST_PYTHON3_REGEX_DL_SUBDIR = python-regex
HOST_PYTHON3_REGEX_NEEDS_HOST_PYTHON = python3

$(eval $(host-python-package))
