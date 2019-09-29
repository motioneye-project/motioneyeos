################################################################################
#
# python-pycurl
#
################################################################################

PYTHON_PYCURL_VERSION = 7.43.0.2
PYTHON_PYCURL_SOURCE = pycurl-$(PYTHON_PYCURL_VERSION).tar.gz
PYTHON_PYCURL_SITE = https://files.pythonhosted.org/packages/e8/e4/0dbb8735407189f00b33d84122b9be52c790c7c3b25286826f4e1bdb7bde
PYTHON_PYCURL_SETUP_TYPE = distutils
PYTHON_PYCURL_BUILD_OPTS = --curl-config=$(STAGING_DIR)/usr/bin/curl-config --with-openssl
PYTHON_PYCURL_INSTALL_TARGET_OPTS = --curl-config=$(STAGING_DIR)/usr/bin/curl-config --with-openssl
PYTHON_PYCURL_ENV = PATH=$(PATH):$(STAGING_DIR)/usr/bin

$(eval $(python-package))
