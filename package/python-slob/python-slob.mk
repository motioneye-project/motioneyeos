################################################################################
#
# python-slob
#
################################################################################

PYTHON_SLOB_VERSION = 31ad0e769360a5b10a4893f686587bb8e48c3895
PYTHON_SLOB_SITE = $(call github,itkach,slob,$(PYTHON_SLOB_VERSION))
PYTHON_SLOB_LICENSE = GPL-3.0
PYTHON_SLOB_LICENSE_FILES = LICENSE
PYTHON_SLOB_SETUP_TYPE = distutils

$(eval $(python-package))
