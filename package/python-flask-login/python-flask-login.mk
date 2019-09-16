################################################################################
#
# python-flask-login
#
################################################################################

PYTHON_FLASK_LOGIN_VERSION = 0.4.1
PYTHON_FLASK_LOGIN_SOURCE = Flask-Login-$(PYTHON_FLASK_LOGIN_VERSION).tar.gz
PYTHON_FLASK_LOGIN_SITE = https://files.pythonhosted.org/packages/c1/ff/bd9a4d2d81bf0c07d9e53e8cd3d675c56553719bbefd372df69bf1b3c1e4
PYTHON_FLASK_LOGIN_LICENSE = MIT
PYTHON_FLASK_LOGIN_LICENSE_FILES = LICENSE
PYTHON_FLASK_LOGIN_SETUP_TYPE = setuptools

$(eval $(python-package))
