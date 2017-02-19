################################################################################
#
# python-flask-login
#
################################################################################

PYTHON_FLASK_LOGIN_VERSION = 0.4.0
PYTHON_FLASK_LOGIN_SOURCE = Flask-Login-$(PYTHON_FLASK_LOGIN_VERSION).tar.gz
PYTHON_FLASK_LOGIN_SITE = https://pypi.python.org/packages/70/96/20cae731ef27084dcb183f3a6e3073d0232f10c1fd7be76729bd7bd4b994
PYTHON_FLASK_LOGIN_LICENSE = MIT
PYTHON_FLASK_LOGIN_LICENSE_FILES = LICENSE
PYTHON_FLASK_LOGIN_SETUP_TYPE = setuptools

$(eval $(python-package))
