################################################################################
#
# python-sentry-sdk
#
################################################################################

PYTHON_SENTRY_SDK_VERSION = 0.6.2
PYTHON_SENTRY_SDK_SOURCE = sentry-sdk-$(PYTHON_SENTRY_SDK_VERSION).tar.gz
PYTHON_SENTRY_SDK_SITE = https://files.pythonhosted.org/packages/92/6f/b7b74d7635e220660c06897213fc6df894d291900c8e2710d72fb67528a7
PYTHON_SENTRY_SDK_SETUP_TYPE = setuptools
PYTHON_SENTRY_SDK_LICENSE = BSD-2-Clause
PYTHON_SENTRY_SDK_LICENSE_FILES = LICENSE

$(eval $(python-package))
