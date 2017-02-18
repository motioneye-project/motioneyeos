################################################################################
#
# python-pycurl
#
################################################################################

PYTHON_PYCURL_VERSION = 7.19.5.1
PYTHON_PYCURL_SOURCE = pycurl-$(PYTHON_PYCURL_VERSION).tar.gz
PYTHON_PYCURL_SITE = http://pypi.python.org/packages/source/p/pycurl
PYTHON_PYCURL_SETUP_TYPE = distutils
PYTHON_PYCURL_BUILD_OPTS = --curl-config=$(STAGING_DIR)/usr/bin/curl-config --with-ssl
PYTHON_PYCURL_ENV = PATH=$(STAGING_DIR)/usr/bin

$(eval $(python-package))
