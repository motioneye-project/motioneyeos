################################################################################
#
# python-pysendfile
#
################################################################################

PYTHON_PYSENDFILE_VERSION = 2.0.1
PYTHON_PYSENDFILE_SITE = $(call github,giampaolo,pysendfile,release-$(PYTHON_PYSENDFILE_VERSION))
PYTHON_PYSENDFILE_SETUP_TYPE = setuptools
PYTHON_PYSENDFILE_LICENSE = MIT
PYTHON_PYSENDFILE_LICENSE_FILES = LICENSE

$(eval $(python-package))
