################################################################################
#
# python-setuptools
#
################################################################################

# "distribute" is a fork of the unmaintained setuptools package. There
# are plans to re-merge it into setuptools; if this happens, we can
# switch back to it.
# See http://pypi.python.org/packages/source/s/setuptools

PYTHON_SETUPTOOLS_VERSION = 0.6.36
PYTHON_SETUPTOOLS_SOURCE  = distribute-$(PYTHON_SETUPTOOLS_VERSION).tar.gz
PYTHON_SETUPTOOLS_SITE    = http://pypi.python.org/packages/source/d/distribute
PYTHON_SETUPTOOLS_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))
