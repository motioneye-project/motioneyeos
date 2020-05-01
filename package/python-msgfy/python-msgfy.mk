################################################################################
#
# python-msgfy
#
################################################################################

PYTHON_MSGFY_VERSION = 0.1.0
PYTHON_MSGFY_SOURCE = msgfy-$(PYTHON_MSGFY_VERSION).tar.gz
PYTHON_MSGFY_SITE = https://files.pythonhosted.org/packages/24/b5/7cc6ba75b6489245f9b75f11a85202b934fa92f6c99a4fa1c639f08d68e8
PYTHON_MSGFY_SETUP_TYPE = setuptools
PYTHON_MSGFY_LICENSE = MIT
PYTHON_MSGFY_LICENSE_FILES = LICENSE

$(eval $(python-package))
