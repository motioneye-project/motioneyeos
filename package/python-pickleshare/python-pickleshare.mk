################################################################################
#
# python-pickleshare
#
################################################################################

PYTHON_PICKLESHARE_VERSION = 0.7.4
PYTHON_PICKLESHARE_SOURCE = pickleshare-$(PYTHON_PICKLESHARE_VERSION).tar.gz
PYTHON_PICKLESHARE_SITE = https://pypi.python.org/packages/69/fe/dd137d84daa0fd13a709e448138e310d9ea93070620c9db5454e234af525
PYTHON_PICKLESHARE_LICENSE = MIT
PYTHON_PICKLESHARE_LICENSE_FILE = LICENSE
PYTHON_PICKLESHARE_SETUP_TYPE = setuptools

$(eval $(python-package))
