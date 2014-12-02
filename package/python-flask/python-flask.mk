################################################################################
#
# python-flask
#
################################################################################

PYTHON_FLASK_VERSION = 0.10.1
PYTHON_FLASK_SOURCE = Flask-$(PYTHON_FLASK_VERSION).tar.gz
PYTHON_FLASK_SITE = http://pypi.python.org/packages/source/F/Flask
PYTHON_FLASK_SETUP_TYPE = setuptools
PYTHON_FLASK_LICENSE = BSD-3c
PYTHON_FLASK_LICENSE_FILES = LICENSE
PYTHON_FLASK_DEPENDENCIES = python-werkzeug python-jinja2 python-itsdangerous

$(eval $(python-package))
