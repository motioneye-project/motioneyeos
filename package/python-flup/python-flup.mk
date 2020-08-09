################################################################################
#
# python-flup
#
################################################################################

PYTHON_FLUP_VERSION = 1.0.3
PYTHON_FLUP_SOURCE = flup-$(PYTHON_FLUP_VERSION).tar.gz
PYTHON_FLUP_SITE = https://files.pythonhosted.org/packages/bb/b5/26cc8f7baf0ddebd3e61a354a2bcc692cfe8005123c37ee3d8507c4c7511
PYTHON_FLUP_LICENSE = BSD-2-Clause, MIT
PYTHON_FLUP_LICENSE_FILES = PKG-INFO
PYTHON_FLUP_SETUP_TYPE = setuptools

$(eval $(python-package))
