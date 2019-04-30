################################################################################
#
# python-flask-sqlalchemy
#
################################################################################

PYTHON_FLASK_SQLALCHEMY_VERSION = 2.4.0
PYTHON_FLASK_SQLALCHEMY_SOURCE = Flask-SQLAlchemy-$(PYTHON_FLASK_SQLALCHEMY_VERSION).tar.gz
PYTHON_FLASK_SQLALCHEMY_SITE = https://files.pythonhosted.org/packages/9b/62/80a56f9d223f0b89cdcf7d592455375f8c9d73866f337fa85f39f45fe0c5
PYTHON_FLASK_SQLALCHEMY_SETUP_TYPE = setuptools
PYTHON_FLASK_SQLALCHEMY_LICENSE = BSD-3c
PYTHON_FLASK_SQLALCHEMY_LICENSE_FILES = PKG-INFO

$(eval $(python-package))
