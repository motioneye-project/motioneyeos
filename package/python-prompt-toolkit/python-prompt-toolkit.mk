################################################################################
#
# python-prompt-toolkit
#
################################################################################

PYTHON_PROMPT_TOOLKIT_VERSION = 1.0.7
PYTHON_PROMPT_TOOLKIT_SOURCE = prompt_toolkit-$(PYTHON_PROMPT_TOOLKIT_VERSION).tar.gz
PYTHON_PROMPT_TOOLKIT_SITE = https://pypi.python.org/packages/dd/55/2fb4883d2b21d072204fd21ca5e6040faa253135554590d0b67380669176
PYTHON_PROMPT_TOOLKIT_SETUP_TYPE = setuptools
PYTHON_PROMPT_TOOLKIT_LICENSE = BSD-3c
PYTHON_PROMPT_TOOLKIT_LICENSE_FILES = LICENSE

$(eval $(python-package))
