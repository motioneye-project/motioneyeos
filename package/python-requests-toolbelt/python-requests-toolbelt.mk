################################################################################
#
# python-requests-toolbelt
#
################################################################################

PYTHON_REQUESTS_TOOLBELT_VERSION = 0.7.0
PYTHON_REQUESTS_TOOLBELT_SOURCE = requests-toolbelt-$(PYTHON_REQUESTS_TOOLBELT_VERSION).tar.gz
PYTHON_REQUESTS_TOOLBELT_SITE = https://pypi.python.org/packages/59/78/1d391d30ebf74079a8e4de6ab66fdca5362903ef2df64496f4697e9bb626
PYTHON_REQUESTS_TOOLBELT_SETUP_TYPE = setuptools
PYTHON_REQUESTS_TOOLBELT_LICENSE = Apache-2.0
PYTHON_REQUESTS_TOOLBELT_LICENSE_FILES = LICENSE

$(eval $(python-package))
