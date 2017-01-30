################################################################################
#
# python-gunicorn
#
################################################################################

PYTHON_GUNICORN_VERSION = 19.6.0
PYTHON_GUNICORN_SOURCE = gunicorn-$(PYTHON_GUNICORN_VERSION).tar.gz
PYTHON_GUNICORN_SITE = https://pypi.python.org/packages/84/ce/7ea5396efad1cef682bbc4068e72a0276341d9d9d0f501da609fab9fcb80
PYTHON_GUNICORN_SETUP_TYPE = setuptools
PYTHON_GUNICORN_LICENSE = MIT
PYTHON_GUNICORN_LICENSE_FILES = LICENSE

$(eval $(python-package))
