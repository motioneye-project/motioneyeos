################################################################################
#
# python-flask
#
################################################################################

PYTHON_FLASK_VERSION = 0.11.1
PYTHON_FLASK_SOURCE = Flask-$(PYTHON_FLASK_VERSION).tar.gz
PYTHON_FLASK_SITE = https://pypi.python.org/packages/55/8a/78e165d30f0c8bb5d57c429a30ee5749825ed461ad6c959688872643ffb3
PYTHON_FLASK_SETUP_TYPE = setuptools
PYTHON_FLASK_LICENSE = BSD-3c
PYTHON_FLASK_LICENSE_FILES = LICENSE

$(eval $(python-package))
