################################################################################
#
# python-iowait
#
################################################################################

PYTHON_IOWAIT_VERSION = 0.2
PYTHON_IOWAIT_SOURCE = iowait-$(PYTHON_IOWAIT_VERSION).tar.gz
PYTHON_IOWAIT_SITE = https://pypi.python.org/packages/65/30/e953673fe9619938e9c74408401cf865f37716da89f61f6e5d9328c0f71e
PYTHON_IOWAIT_SETUP_TYPE = distutils
PYTHON_IOWAIT_LICENSE = LGPLv3+
PYTHON_IOWAIT_LICENSE_FILES = COPYING.LESSER

$(eval $(python-package))
