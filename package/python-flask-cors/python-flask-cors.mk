################################################################################
#
# python-flask-cors
#
################################################################################

PYTHON_FLASK_CORS_VERSION = 3.0.8
PYTHON_FLASK_CORS_SOURCE = Flask-Cors-$(PYTHON_FLASK_CORS_VERSION).tar.gz
PYTHON_FLASK_CORS_SITE = https://files.pythonhosted.org/packages/9e/11/ca8b95c5bf9644471601e425f0de8cbd09a506bb6c24842cb17a6cd1eea8
PYTHON_FLASK_CORS_SETUP_TYPE = setuptools
PYTHON_FLASK_CORS_LICENSE = MIT
PYTHON_FLASK_CORS_LICENSE_FILES = LICENSE

$(eval $(python-package))
