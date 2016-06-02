################################################################################
#
# python-werkzeug
#
################################################################################

PYTHON_WERKZEUG_VERSION = 0.11.10
PYTHON_WERKZEUG_SOURCE = Werkzeug-$(PYTHON_WERKZEUG_VERSION).tar.gz
PYTHON_WERKZEUG_SITE = https://pypi.python.org/packages/b7/7f/44d3cfe5a12ba002b253f6985a4477edfa66da53787a2a838a40f6415263
PYTHON_WERKZEUG_SETUP_TYPE = setuptools
PYTHON_WERKZEUG_LICENSE = BSD-3c
PYTHON_WERKZEUG_LICENSE_FILES = LICENSE

$(eval $(python-package))
