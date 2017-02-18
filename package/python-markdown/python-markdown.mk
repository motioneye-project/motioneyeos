################################################################################
#
# python-markdown
#
################################################################################

PYTHON_MARKDOWN_VERSION = 2.5.2
PYTHON_MARKDOWN_SOURCE = Markdown-$(PYTHON_MARKDOWN_VERSION).tar.gz
PYTHON_MARKDOWN_SITE = http://pypi.python.org/packages/source/M/Markdown
PYTHON_MARKDOWN_LICENSE = BSD-3c
PYTHON_MARKDOWN_LICENSE_FILES = LICENSE.md
PYTHON_MARKDOWN_SETUP_TYPE = distutils

$(eval $(python-package))
$(eval $(host-python-package))
