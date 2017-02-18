################################################################################
#
# python-certifi
#
################################################################################

PYTHON_CERTIFI_VERSION = 2016.2.28
PYTHON_CERTIFI_SOURCE = certifi-$(PYTHON_CERTIFI_VERSION).tar.gz
PYTHON_CERTIFI_SITE = https://pypi.python.org/packages/source/c/certifi
PYTHON_CERTIFI_SETUP_TYPE = setuptools
PYTHON_CERTIFI_LICENSE = ISC (Python code), MPL-2.0 (cacert.pem)
PYTHON_CERTIFI_LICENSE_FILES = LICENSE

$(eval $(python-package))
