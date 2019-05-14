################################################################################
#
# python-subprocess32
#
################################################################################

PYTHON_SUBPROCESS32_VERSION = 3.5.3
PYTHON_SUBPROCESS32_SOURCE = subprocess32-$(PYTHON_SUBPROCESS32_VERSION).tar.gz
PYTHON_SUBPROCESS32_SITE = https://files.pythonhosted.org/packages/be/2b/beeba583e9877e64db10b52a96915afc0feabf7144dcbf2a0d0ea68bf73d
PYTHON_SUBPROCESS32_SETUP_TYPE = setuptools
PYTHON_SUBPROCESS32_LICENSE = Python-2.0
PYTHON_SUBPROCESS32_LICENSE_FILES = LICENSE

$(eval $(python-package))
