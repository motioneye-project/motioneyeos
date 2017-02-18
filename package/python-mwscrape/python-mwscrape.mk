################################################################################
#
# python-mwscrape
#
################################################################################

PYTHON_MWSCRAPE_VERSION = 6a58d7801eb1e884fd0516f1adbedbd4481c10e6
PYTHON_MWSCRAPE_SITE = $(call github,itkach,mwscrape,$(PYTHON_MWSCRAPE_VERSION))
PYTHON_MWSCRAPE_LICENSE = MPL-2.0
PYTHON_MWSCRAPE_LICENSE_FILES = LICENSE.txt
PYTHON_MWSCRAPE_SETUP_TYPE = distutils

$(eval $(python-package))
