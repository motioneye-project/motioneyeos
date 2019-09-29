################################################################################
#
# python-sdnotify
#
################################################################################

PYTHON_SDNOTIFY_VERSION = 0.3.2
PYTHON_SDNOTIFY_SOURCE = sdnotify-$(PYTHON_SDNOTIFY_VERSION).tar.gz
PYTHON_SDNOTIFY_SITE = https://files.pythonhosted.org/packages/ce/d8/9fdc36b2a912bf78106de4b3f0de3891ff8f369e7a6f80be842b8b0b6bd5
PYTHON_SDNOTIFY_SETUP_TYPE = distutils
PYTHON_SDNOTIFY_LICENSE = MIT
PYTHON_SDNOTIFY_LICENSE_FILES = LICENSE.txt

$(eval $(python-package))
