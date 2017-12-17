################################################################################
#
# python-flask
#
################################################################################

PYTHON_FLASK_VERSION = 0.12
PYTHON_FLASK_SOURCE = Flask-$(PYTHON_FLASK_VERSION).tar.gz
PYTHON_FLASK_SITE = https://pypi.python.org/packages/4b/3a/4c20183df155dd2e39168e35d53a388efb384a512ca6c73001d8292c094a
PYTHON_FLASK_SETUP_TYPE = setuptools
PYTHON_FLASK_LICENSE = BSD-3c
PYTHON_FLASK_LICENSE_FILES = LICENSE

$(eval $(python-package))
