################################################################################
#
# python-msgfy
#
################################################################################

PYTHON_MSGFY_VERSION = 0.0.7
PYTHON_MSGFY_SOURCE = msgfy-$(PYTHON_MSGFY_VERSION).tar.gz
PYTHON_MSGFY_SITE = https://files.pythonhosted.org/packages/23/82/b61a8353c36e60c2c8291c56ad7d00aa37918ef56811727510acada09f7f
PYTHON_MSGFY_SETUP_TYPE = setuptools
PYTHON_MSGFY_LICENSE = MIT
PYTHON_MSGFY_LICENSE_FILES = LICENSE

$(eval $(python-package))
