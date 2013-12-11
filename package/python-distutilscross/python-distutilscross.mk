################################################################################
#
# python-distutilscross
#
################################################################################

PYTHON_DISTUTILSCROSS_VERSION = 0.1
PYTHON_DISTUTILSCROSS_SOURCE  = distutilscross-$(PYTHON_DISTUTILSCROSS_VERSION).tar.gz
PYTHON_DISTUTILSCROSS_SITE    = http://pypi.python.org/packages/source/d/distutilscross
PYTHON_DISTUTILSCROSS_SETUP_TYPE = setuptools

$(eval $(host-python-package))
