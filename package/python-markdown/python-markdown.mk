################################################################################
#
# python-markdown
#
################################################################################

PYTHON_MARKDOWN_VERSION = 3.0.1
PYTHON_MARKDOWN_SOURCE = Markdown-$(PYTHON_MARKDOWN_VERSION).tar.gz
PYTHON_MARKDOWN_SITE = https://files.pythonhosted.org/packages/3c/52/7bae9e99a7a4be6af4a713fe9b692777e6468d28991c54c273dfb6ec9fb2
PYTHON_MARKDOWN_LICENSE = BSD-3-Clause
PYTHON_MARKDOWN_LICENSE_FILES = LICENSE.md
PYTHON_MARKDOWN_SETUP_TYPE = setuptools

$(eval $(python-package))
$(eval $(host-python-package))
