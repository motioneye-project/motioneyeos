################################################################################
#
# python-m2crypto
#
################################################################################

PYTHON_M2CRYPTO_VERSION = 0.21.1
PYTHON_M2CRYPTO_SITE = http://pypi.python.org/packages/source/M/M2Crypto
PYTHON_M2CRYPTO_SOURCE = M2Crypto-$(PYTHON_M2CRYPTO_VERSION).tar.gz
HOST_PYTHON_M2CRYPTO_DEPENDENCIES = host-openssl host-python host-python-setuptools host-swig

define HOST_PYTHON_M2CRYPTO_BUILD_CMDS
	(cd $(@D); \
	$(HOST_CONFIGURE_OPTS) \
	PYTHONXCPREFIX="$(HOST_DIR)/usr/" \
	LDFLAGS="-L$(HOST_DIR)/lib -L$(HOST_DIR)/usr/lib" \
	$(HOST_DIR)/usr/bin/python setup.py build_ext --openssl=$(HOST_DIR)/usr)
endef

define HOST_PYTHON_M2CRYPTO_INSTALL_CMDS
	(cd $(@D); \
	PYTHONPATH=$(HOST_DIR)/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages \
	$(HOST_DIR)/usr/bin/python setup.py install --prefix=$(HOST_DIR)/usr)
endef

$(eval $(host-generic-package))
