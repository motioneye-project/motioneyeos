################################################################################
#
# python-flask-jsonrpc
#
################################################################################

PYTHON_FLASK_JSONRPC_VERSION = 0.3
PYTHON_FLASK_JSONRPC_SOURCE = Flask-JSONRPC-$(PYTHON_FLASK_JSONRPC_VERSION).tar.gz
PYTHON_FLASK_JSONRPC_SITE = http://pypi.python.org/packages/source/F/Flask-JSONRPC
PYTHON_FLASK_JSONRPC_LICENSE = BSD-3c
PYTHON_FLASK_JSONRPC_LICENSE_FILES = setup.py
PYTHON_FLASK_JSONRPC_SETUP_TYPE = setuptools

$(eval $(python-package))
