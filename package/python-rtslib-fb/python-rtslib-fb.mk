################################################################################
#
# python-rtslib-fb
#
################################################################################

# When upgrading the version, be sure to also upgrade
# python-configshell-fb and targetcli-fb at the same time.
PYTHON_RTSLIB_FB_VERSION = 2.1.fb57
# Do not switch site to PyPI: it does not contain the latest version.
PYTHON_RTSLIB_FB_SITE = $(call github,open-iscsi,rtslib-fb,v$(PYTHON_RTSLIB_FB_VERSION))
PYTHON_RTSLIB_FB_LICENSE = Apache-2.0
PYTHON_RTSLIB_FB_LICENSE_FILES = COPYING
PYTHON_RTSLIB_FB_SETUP_TYPE = setuptools
PYTHON_RTSLIB_FB_DEPENDENCIES = python-six

$(eval $(python-package))
