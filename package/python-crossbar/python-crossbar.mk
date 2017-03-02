################################################################################
#
# python-crossbar
#
################################################################################

# don't bump version as newer setuptools package is needed,
# that still didn't make its way into Buildroot
PYTHON_CROSSBAR_VERSION = 0.14.0
PYTHON_CROSSBAR_SOURCE = crossbar-$(PYTHON_CROSSBAR_VERSION).tar.gz
PYTHON_CROSSBAR_SITE = https://pypi.python.org/packages/f0/9a/e0b77e15698c47b6293655bc0e1996dd8e87bd8af7bc7434a5c8281a024e
PYTHON_CROSSBAR_LICENSE = AGPLv3
PYTHON_CROSSBAR_LICENSE_FILES = LICENSE
PYTHON_CROSSBAR_SETUP_TYPE = setuptools

$(eval $(python-package))
