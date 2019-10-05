################################################################################
#
# python-websocket-client
#
################################################################################

PYTHON_WEBSOCKET_CLIENT_VERSION = 0.56.0
PYTHON_WEBSOCKET_CLIENT_SOURCE = websocket_client-$(PYTHON_WEBSOCKET_CLIENT_VERSION).tar.gz
PYTHON_WEBSOCKET_CLIENT_SITE = https://files.pythonhosted.org/packages/c5/01/8c9c7de6c46f88e70b5a3276c791a2be82ae83d8e0d0cc030525ee2866fd
PYTHON_WEBSOCKET_CLIENT_SETUP_TYPE = setuptools
# Project was under LGPL-2.1+, but was relicensed under
# BSD-3-Clause. The LICENSE file contains the BSD-3-Clause text, but
# the source files still contain a LGPL-2.1+ header.
PYTHON_WEBSOCKET_CLIENT_LICENSE = LGPL-2.1+, BSD-3-Clause
PYTHON_WEBSOCKET_CLIENT_LICENSE_FILES = LICENSE

$(eval $(python-package))
