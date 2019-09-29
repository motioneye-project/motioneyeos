################################################################################
#
# python-six
#
################################################################################

PYTHON_SIX_VERSION = 1.12.0
PYTHON_SIX_SOURCE = six-$(PYTHON_SIX_VERSION).tar.gz
PYTHON_SIX_SITE = https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca
PYTHON_SIX_SETUP_TYPE = setuptools
PYTHON_SIX_LICENSE = MIT
PYTHON_SIX_LICENSE_FILES = LICENSE

$(eval $(python-package))
$(eval $(host-python-package))
