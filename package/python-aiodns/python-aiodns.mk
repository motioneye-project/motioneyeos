################################################################################
#
# python-aiodns
#
################################################################################

PYTHON_AIODNS_VERSION = 2.0.0
PYTHON_AIODNS_SOURCE = aiodns-$(PYTHON_AIODNS_VERSION).tar.gz
PYTHON_AIODNS_SITE = https://files.pythonhosted.org/packages/30/2e/b86ce168485b68d40c6a810838669deacf0abf41845c383659c2b613e69f
PYTHON_AIODNS_SETUP_TYPE = setuptools
PYTHON_AIODNS_LICENSE = MIT
PYTHON_AIODNS_LICENSE_FILES = LICENSE

$(eval $(python-package))
