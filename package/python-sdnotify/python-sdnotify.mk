################################################################################
#
# python-sdnotify
#
################################################################################

PYTHON_SDNOTIFY_VERSION = 0.3.0
PYTHON_SDNOTIFY_SOURCE = sdnotify-$(PYTHON_SDNOTIFY_VERSION).tar.gz
PYTHON_SDNOTIFY_SITE = https://pypi.python.org/packages/6f/ef/d57f930ba403b2e6440bd7ab14dbdd7ce1a1bfb5617bba62a950d04bfa34
PYTHON_SDNOTIFY_SETUP_TYPE = distutils
PYTHON_SDNOTIFY_LICENSE = MIT

$(eval $(python-package))
