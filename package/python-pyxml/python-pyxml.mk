################################################################################
#
# python-pyxml
#
################################################################################

PYTHON_PYXML_VERSION = 0.8.4
PYTHON_PYXML_SOURCE = PyXML-$(PYTHON_PYXML_VERSION).tar.gz
PYTHON_PYXML_SITE = http://downloads.sourceforge.net/project/pyxml/pyxml/$(PYTHON_PYXML_VERSION)/
PYTHON_PYXML_LICENSE = BSD-3c
PYTHON_PYXML_LICENSE_FILES = LICENCE
PYTHON_PYXML_SETUP_TYPE = distutils
PYTHON_PYXML_DEPENDENCIES = expat
PYTHON_PYXML_BUILD_OPTS = --with-libexpat=$(STAGING_DIR)/usr
PYTHON_PYXML_INSTALL_TARGET_OPTS = --with-libexpat=$(STAGING_DIR)/usr

$(eval $(python-package))
