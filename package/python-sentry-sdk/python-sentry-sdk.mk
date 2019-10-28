################################################################################
#
# python-sentry-sdk
#
################################################################################

PYTHON_SENTRY_SDK_VERSION = 0.13.1
PYTHON_SENTRY_SDK_SOURCE = sentry-sdk-$(PYTHON_SENTRY_SDK_VERSION).tar.gz
PYTHON_SENTRY_SDK_SITE = https://files.pythonhosted.org/packages/e2/5f/1f5881e98746c16464d46ae9d6ccdd6ce3c01c7e13093ea8a7d917642ee7
PYTHON_SENTRY_SDK_SETUP_TYPE = setuptools
PYTHON_SENTRY_SDK_LICENSE = BSD-2-Clause
PYTHON_SENTRY_SDK_LICENSE_FILES = LICENSE

$(eval $(python-package))
