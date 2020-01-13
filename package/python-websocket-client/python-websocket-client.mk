################################################################################
#
# python-websocket-client
#
################################################################################

PYTHON_WEBSOCKET_CLIENT_VERSION = 0.57.0
PYTHON_WEBSOCKET_CLIENT_SOURCE = websocket_client-$(PYTHON_WEBSOCKET_CLIENT_VERSION).tar.gz
PYTHON_WEBSOCKET_CLIENT_SITE = https://files.pythonhosted.org/packages/8b/0f/52de51b9b450ed52694208ab952d5af6ebbcbce7f166a48784095d930d8c
PYTHON_WEBSOCKET_CLIENT_SETUP_TYPE = setuptools
# Project was under LGPL-2.1+, but was relicensed under
# BSD-3-Clause. The LICENSE file contains the BSD-3-Clause text, but
# the source files still contain a LGPL-2.1+ header.
PYTHON_WEBSOCKET_CLIENT_LICENSE = LGPL-2.1+, BSD-3-Clause
PYTHON_WEBSOCKET_CLIENT_LICENSE_FILES = LICENSE

$(eval $(python-package))
