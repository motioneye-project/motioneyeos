################################################################################
#
# python-prompt-toolkit
#
################################################################################

PYTHON_PROMPT_TOOLKIT_VERSION = 1.0.3
PYTHON_PROMPT_TOOLKIT_SOURCE = prompt_toolkit-$(PYTHON_PROMPT_TOOLKIT_VERSION).tar.gz
PYTHON_PROMPT_TOOLKIT_SITE = https://pypi.python.org/packages/8d/de/412f23919929c01e6b55183e124623f705e4b91796d3d2dce2cb53d595ad
PYTHON_PROMPT_TOOLKIT_SETUP_TYPE = setuptools
PYTHON_PROMPT_TOOLKIT_LICENSE = BSD-3c
PYTHON_PROMPT_TOOLKIT_LICENSE_FILES = LICENSE

$(eval $(python-package))
