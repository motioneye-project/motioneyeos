################################################################################
#
# python-termcolor
#
################################################################################

PYTHON_TERMCOLOR_VERSION = 1.1.0
PYTHON_TERMCOLOR_SOURCE = termcolor-$(PYTHON_TERMCOLOR_VERSION).tar.gz
PYTHON_TERMCOLOR_SITE = https://files.pythonhosted.org/packages/8a/48/a76be51647d0eb9f10e2a4511bf3ffb8cc1e6b14e9e4fab46173aa79f981
PYTHON_TERMCOLOR_SETUP_TYPE = distutils
PYTHON_TERMCOLOR_LICENSE = MIT
PYTHON_TERMCOLOR_LICENSE_FILES = COPYING.txt

$(eval $(python-package))
