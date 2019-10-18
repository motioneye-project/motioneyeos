################################################################################
#
# python-pip
#
################################################################################

PYTHON_PIP_VERSION = 19.3.1
PYTHON_PIP_SOURCE = pip-$(PYTHON_PIP_VERSION).tar.gz
PYTHON_PIP_SITE = https://files.pythonhosted.org/packages/ce/ea/9b445176a65ae4ba22dce1d93e4b5fe182f953df71a145f557cffaffc1bf
PYTHON_PIP_SETUP_TYPE = setuptools
PYTHON_PIP_LICENSE = MIT
PYTHON_PIP_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
