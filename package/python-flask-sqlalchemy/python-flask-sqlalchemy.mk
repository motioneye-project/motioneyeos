################################################################################
#
# python-flask-sqlalchemy
#
################################################################################

PYTHON_FLASK_SQLALCHEMY_VERSION = 2.4.1
PYTHON_FLASK_SQLALCHEMY_SOURCE = Flask-SQLAlchemy-$(PYTHON_FLASK_SQLALCHEMY_VERSION).tar.gz
PYTHON_FLASK_SQLALCHEMY_SITE = https://files.pythonhosted.org/packages/52/7a/35bacbedafdc652d5198b80eb22eacccae0c97a49740a45da828b05cc37b
PYTHON_FLASK_SQLALCHEMY_SETUP_TYPE = setuptools
PYTHON_FLASK_SQLALCHEMY_LICENSE = BSD-3-Clause
PYTHON_FLASK_SQLALCHEMY_LICENSE_FILES = LICENSE.rst

$(eval $(python-package))
