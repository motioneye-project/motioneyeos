################################################################################
#
# python-configshell-fb
#
################################################################################

PYTHON_CONFIGSHELL_FB_VERSION = v1.1.fb15
PYTHON_CONFIGSHELL_FB_SITE = $(call github,agrover,configshell-fb,$(PYTHON_CONFIGSHELL_FB_VERSION))
PYTHON_CONFIGSHELL_FB_LICENSE = Apache-2.0
PYTHON_CONFIGSHELL_FB_LICENSE_FILES = COPYING
PYTHON_CONFIGSHELL_FB_SETUP_TYPE = setuptools
PYTHON_CONFIGSHELL_FB_DEPENDENCIES = python-pyparsing python-urwid

$(eval $(python-package))
