################################################################################
#
# python-webpy
#
################################################################################

# corresponds to 0.39
PYTHON_WEBPY_VERSION = 6df75fe581e0e838d28334d5c53f52421560d38b
PYTHON_WEBPY_SITE = $(call github,webpy,webpy,$(PYTHON_WEBPY_VERSION))
PYTHON_WEBPY_SETUP_TYPE = setuptools
PYTHON_WEBPY_LICENSE = Public Domain, CherryPy License
PYTHON_WEBPY_LICENSE_FILES = LICENSE.txt web/wsgiserver/LICENSE.txt

$(eval $(python-package))
