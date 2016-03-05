################################################################################
#
# python-m2crypto
#
################################################################################

PYTHON_M2CRYPTO_VERSION = 0.22.5
PYTHON_M2CRYPTO_SITE = http://pypi.python.org/packages/source/M/M2Crypto
PYTHON_M2CRYPTO_SOURCE = M2Crypto-$(PYTHON_M2CRYPTO_VERSION).tar.gz
PYTHON_M2CRYPTO_SETUP_TYPE = setuptools
HOST_PYTHON_M2CRYPTO_DEPENDENCIES = host-openssl host-swig

# We need to use python2 because m2crypto is not python3 compliant.
HOST_PYTHON_M2CRYPTO_NEEDS_HOST_PYTHON = python2

# The --openssl option that allows to specify a custom path to OpenSSL
# can only be used with the non-default build_ext setup.py command,
# and calling this command directly fails. To work around this, simply
# hardcode the path to OpenSSL in setup.py.
# Bug reported at https://gitlab.com/m2crypto/m2crypto/issues/89
define HOST_PYTHON_M2CRYPTO_SET_OPENSSL_PATH
	$(SED) "s%self.openssl = '/usr'%self.openssl = '$(HOST_DIR)/usr'%" \
		$(@D)/setup.py
endef

HOST_PYTHON_M2CRYPTO_POST_PATCH_HOOKS += HOST_PYTHON_M2CRYPTO_SET_OPENSSL_PATH

$(eval $(host-python-package))
