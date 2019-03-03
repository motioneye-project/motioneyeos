################################################################################
#
# python-aiomonitor
#
################################################################################

PYTHON_AIOMONITOR_VERSION = 0.4.3
PYTHON_AIOMONITOR_SOURCE = aiomonitor-$(PYTHON_AIOMONITOR_VERSION).tar.gz
PYTHON_AIOMONITOR_SITE = https://files.pythonhosted.org/packages/11/27/2d25a3318e57181e04d2694768f0e1e621b64606d8424076790caa29e401
PYTHON_AIOMONITOR_SETUP_TYPE = setuptools
PYTHON_AIOMONITOR_LICENSE = Apache-2.0
PYTHON_AIOMONITOR_LICENSE_FILES = LICENSE

$(eval $(python-package))
