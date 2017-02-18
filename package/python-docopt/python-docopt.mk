################################################################################
#
# python-docopt
#
################################################################################

PYTHON_DOCOPT_VERSION = 0.6.2
PYTHON_DOCOPT_SITE = $(call github,docopt,docopt,$(PYTHON_DOCOPT_VERSION))
PYTHON_DOCOPT_LICENSE = MIT
PYTHON_DOCOPT_LICENSE_FILES = LICENSE-MIT
PYTHON_DOCOPT_SETUP_TYPE = setuptools

$(eval $(python-package))
