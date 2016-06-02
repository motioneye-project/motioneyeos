################################################################################
#
# python-flask
#
################################################################################

PYTHON_FLASK_VERSION = 0.11
PYTHON_FLASK_SOURCE = Flask-$(PYTHON_FLASK_VERSION).tar.gz
PYTHON_FLASK_SITE = https://pypi.python.org/packages/dc/ca/c0ed9cc90c079085c698e284b672edbc1ffd6866b1830574095cbc5b7752
PYTHON_FLASK_SETUP_TYPE = setuptools
PYTHON_FLASK_LICENSE = BSD-3c
PYTHON_FLASK_LICENSE_FILES = LICENSE

$(eval $(python-package))
