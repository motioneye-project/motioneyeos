################################################################################
#
# python-configshell-fb
#
################################################################################

# When upgrading the version, be sure to also upgrade python-rtslib-fb
# and targetcli-fb at the same time.
PYTHON_CONFIGSHELL_FB_VERSION = 1.1.fb18
PYTHON_CONFIGSHELL_FB_SITE = $(call github,open-iscsi,configshell-fb,v$(PYTHON_CONFIGSHELL_FB_VERSION))
PYTHON_CONFIGSHELL_FB_LICENSE = Apache-2.0
PYTHON_CONFIGSHELL_FB_LICENSE_FILES = COPYING
PYTHON_CONFIGSHELL_FB_SETUP_TYPE = setuptools
PYTHON_CONFIGSHELL_FB_DEPENDENCIES = python-pyparsing python-six python-urwid

$(eval $(python-package))
