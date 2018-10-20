################################################################################
#
# python-autobahn
#
################################################################################

PYTHON_AUTOBAHN_VERSION = 18.10.1
PYTHON_AUTOBAHN_SOURCE = autobahn-$(PYTHON_AUTOBAHN_VERSION).tar.gz
PYTHON_AUTOBAHN_SITE = https://files.pythonhosted.org/packages/e3/42/8a8ba7e371c5d0cbacf42cafd9f562e12cab613edb1f752b6ddfa2f3b280
PYTHON_AUTOBAHN_LICENSE = MIT
PYTHON_AUTOBAHN_LICENSE_FILES = LICENSE
PYTHON_AUTOBAHN_SETUP_TYPE = setuptools

$(eval $(python-package))
