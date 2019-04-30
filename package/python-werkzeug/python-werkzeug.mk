################################################################################
#
# python-werkzeug
#
################################################################################

PYTHON_WERKZEUG_VERSION = 0.15.2
PYTHON_WERKZEUG_SOURCE = Werkzeug-$(PYTHON_WERKZEUG_VERSION).tar.gz
PYTHON_WERKZEUG_SITE = https://files.pythonhosted.org/packages/f3/c8/fa7e1a0283267bee8efa10c665d8dca27e591face7e333c789c85671b3ab
PYTHON_WERKZEUG_SETUP_TYPE = setuptools
PYTHON_WERKZEUG_LICENSE = BSD-3-Clause
PYTHON_WERKZEUG_LICENSE_FILES = LICENSE.rst

$(eval $(python-package))
