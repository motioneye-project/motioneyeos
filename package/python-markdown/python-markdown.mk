################################################################################
#
# python-markdown
#
################################################################################

PYTHON_MARKDOWN_VERSION = 2.6.7
PYTHON_MARKDOWN_SOURCE = Markdown-$(PYTHON_MARKDOWN_VERSION).tar.gz
PYTHON_MARKDOWN_SITE = https://pypi.python.org/packages/d4/32/642bd580c577af37b00a1eb59b0eaa996f2d11dfe394f3dd0c7a8a2de81a
PYTHON_MARKDOWN_LICENSE = BSD-3c
PYTHON_MARKDOWN_LICENSE_FILES = LICENSE.md
PYTHON_MARKDOWN_SETUP_TYPE = distutils

$(eval $(python-package))
$(eval $(host-python-package))
