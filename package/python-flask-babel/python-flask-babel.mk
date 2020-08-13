################################################################################
#
# python-flask-babel
#
################################################################################

PYTHON_FLASK_BABEL_VERSION = 1.0.0
PYTHON_FLASK_BABEL_SOURCE = Flask-Babel-$(PYTHON_FLASK_BABEL_VERSION).tar.gz
PYTHON_FLASK_BABEL_SITE = https://files.pythonhosted.org/packages/7a/73/e4a9532ca11daeead1a99251f2ec1a5faf98117b83dbfe1b30535004cd98
PYTHON_FLASK_BABEL_LICENSE = BSD-3-Clause
PYTHON_FLASK_BABEL_SETUP_TYPE = setuptools
PYTHON_FLASK_BABEL_LICENSE_FILES = LICENSE

$(eval $(python-package))
