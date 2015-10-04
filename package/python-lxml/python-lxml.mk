################################################################################
#
# python-lxml
#
################################################################################

PYTHON_LXML_VERSION = 3.4.4
PYTHON_LXML_SITE = http://lxml.de/files
PYTHON_LXML_SOURCE = lxml-$(PYTHON_LXML_VERSION).tgz

# Not including the GPL, because it is used only for the test scripts.
PYTHON_LXML_LICENSE = BSD-3c, Others
PYTHON_LXML_LICENSE_FILES = \
	LICENSES.txt \
	doc/licenses/BSD.txt \
	doc/licenses/elementtree.txt \
	src/lxml/isoschematron/resources/rng/iso-schematron.rng

# python-lxml can use either setuptools, or distutils as a fallback.
# So, we use setuptools.
PYTHON_LXML_SETUP_TYPE = setuptools

PYTHON_LXML_DEPENDENCIES = libxml2 libxslt zlib

# python-lxml needs these scripts in order to properly detect libxml2 and
# libxslt compiler and linker flags
PYTHON_LXML_BUILD_OPTS = \
	--with-xslt-config=$(STAGING_DIR)/usr/bin/xslt-config \
	--with-xml2-config=$(STAGING_DIR)/usr/bin/xml2-config

$(eval $(python-package))
