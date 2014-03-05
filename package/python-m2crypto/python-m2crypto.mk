################################################################################
#
# python-m2crypto
#
################################################################################

PYTHON_M2CRYPTO_VERSION = 0.21.1
PYTHON_M2CRYPTO_SITE = http://pypi.python.org/packages/source/M/M2Crypto
PYTHON_M2CRYPTO_SOURCE = M2Crypto-$(PYTHON_M2CRYPTO_VERSION).tar.gz
PYTHON_M2CRYPTO_SETUP_TYPE = setuptools
HOST_PYTHON_M2CRYPTO_DEPENDENCIES = host-openssl host-swig

# We need to use python2 because m2crypto is not python3 compliant.
HOST_PYTHON_M2CRYPTO_NEEDS_HOST_PYTHON = python2

# * We need to override the build commands to be able to use build_ext,
#   which accepts the --openssl option.
# * Use python2 interpreter to avoid trying building some python3 objects.
define HOST_PYTHON_M2CRYPTO_BUILD_CMDS
	(cd $(@D); \
		$(HOST_PKG_PYTHON_SETUPTOOLS_ENV) \
		$(HOST_DIR)/usr/bin/python2 setup.py build_ext \
			--openssl=$(HOST_DIR)/usr)
endef

$(eval $(host-python-package))
