################################################################################
#
# python-requests-toolbelt
#
################################################################################

PYTHON_REQUESTS_TOOLBELT_VERSION = 0.9.1
PYTHON_REQUESTS_TOOLBELT_SOURCE = requests-toolbelt-$(PYTHON_REQUESTS_TOOLBELT_VERSION).tar.gz
PYTHON_REQUESTS_TOOLBELT_SITE = https://files.pythonhosted.org/packages/28/30/7bf7e5071081f761766d46820e52f4b16c8a08fef02d2eb4682ca7534310
PYTHON_REQUESTS_TOOLBELT_SETUP_TYPE = setuptools
PYTHON_REQUESTS_TOOLBELT_LICENSE = Apache-2.0
PYTHON_REQUESTS_TOOLBELT_LICENSE_FILES = LICENSE

$(eval $(python-package))
