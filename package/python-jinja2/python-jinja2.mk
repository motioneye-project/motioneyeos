################################################################################
#
# python-jinja2
#
################################################################################

PYTHON_JINJA2_VERSION = 2.7.3
PYTHON_JINJA2_SOURCE = Jinja2-$(PYTHON_JINJA2_VERSION).tar.gz
PYTHON_JINJA2_SITE = http://pypi.python.org/packages/source/J/Jinja2
PYTHON_JINJA2_SETUP_TYPE = setuptools
PYTHON_JINJA2_LICENSE = BSD-3c
PYTHON_JINJA2_LICENSE_FILES = LICENSE

$(eval $(python-package))
