################################################################################
#
# python-prompt-toolkit
#
################################################################################

PYTHON_PROMPT_TOOLKIT_VERSION = 2.0.9
PYTHON_PROMPT_TOOLKIT_SOURCE = prompt_toolkit-$(PYTHON_PROMPT_TOOLKIT_VERSION).tar.gz
PYTHON_PROMPT_TOOLKIT_SITE = https://files.pythonhosted.org/packages/94/a0/57dc47115621d9b3fcc589848cdbcbb6c4c130186e8fc4c4704766a7a699
PYTHON_PROMPT_TOOLKIT_SETUP_TYPE = setuptools
PYTHON_PROMPT_TOOLKIT_LICENSE = BSD-3-Clause
PYTHON_PROMPT_TOOLKIT_LICENSE_FILES = LICENSE

$(eval $(python-package))
