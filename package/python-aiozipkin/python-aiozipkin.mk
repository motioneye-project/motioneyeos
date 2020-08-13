################################################################################
#
# python-aiozipkin
#
################################################################################

PYTHON_AIOZIPKIN_VERSION = 0.6.0
PYTHON_AIOZIPKIN_SOURCE = aiozipkin-$(PYTHON_AIOZIPKIN_VERSION).tar.gz
PYTHON_AIOZIPKIN_SITE = https://files.pythonhosted.org/packages/8d/14/33c79497c3082dd93172f834e4f3d1d6d0eb9b957b6885c919ca73462ed6
PYTHON_AIOZIPKIN_SETUP_TYPE = setuptools
PYTHON_AIOZIPKIN_LICENSE = Apache-2.0
PYTHON_AIOZIPKIN_LICENSE_FILES = LICENSE

$(eval $(python-package))
