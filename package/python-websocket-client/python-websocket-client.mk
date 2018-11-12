################################################################################
#
# python-websocket-client
#
################################################################################

PYTHON_WEBSOCKET_CLIENT_VERSION = 0.47.0
PYTHON_WEBSOCKET_CLIENT_SOURCE = websocket_client-$(PYTHON_WEBSOCKET_CLIENT_VERSION).tar.gz
PYTHON_WEBSOCKET_CLIENT_SITE = https://pypi.python.org/packages/c9/bb/8d3dd9063cfe0cd5d03fe6a1f74ddd948f384e9c1eff0eb978f3976a7d27
PYTHON_WEBSOCKET_CLIENT_SETUP_TYPE = setuptools
PYTHON_WEBSOCKET_CLIENT_LICENSE = LGPL-2.1+
PYTHON_WEBSOCKET_CLIENT_LICENSE_FILES = LICENSE

$(eval $(python-package))
