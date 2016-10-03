################################################################################
#
# python-flask-jsonrpc
#
################################################################################

PYTHON_FLASK_JSONRPC_VERSION = 0.3.1
PYTHON_FLASK_JSONRPC_SOURCE = Flask-JSONRPC-$(PYTHON_FLASK_JSONRPC_VERSION).tar.gz
PYTHON_FLASK_JSONRPC_SITE = https://pypi.python.org/packages/cb/1f/e6d66e8498609ba04bac76155b2ea884df95531e93501bf4ef009d40a83c
PYTHON_FLASK_JSONRPC_LICENSE = BSD-3c
PYTHON_FLASK_JSONRPC_LICENSE_FILES = setup.py
PYTHON_FLASK_JSONRPC_SETUP_TYPE = setuptools

$(eval $(python-package))
