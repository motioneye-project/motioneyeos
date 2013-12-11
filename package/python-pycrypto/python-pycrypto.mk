################################################################################
#
# python-pycrypto
#
################################################################################

PYTHON_PYCRYPTO_VERSION = 2.6
PYTHON_PYCRYPTO_SOURCE = pycrypto-$(PYTHON_PYCRYPTO_VERSION).tar.gz
PYTHON_PYCRYPTO_SITE = http://ftp.dlitz.net/pub/dlitz/crypto/pycrypto
PYTHON_PYCRYPTO_SETUP_TYPE = distutils

PYTHON_PYCRYPTO_LICENSE = Public Domain, Python 2.2 License (HMAC.py, setup.py)
PYTHON_PYCRYPTO_LICENSE_FILES = COPYRIGHT LEGAL/copy/LICENSE.libtom \
		LEGAL/copy/LICENSE.orig LEGAL/copy/LICENSE.python-2.2

PYTHON_PYCRYPTO_DEPENDENCIES = gmp

# The configure step needs to be run outside of the setup.py since it isn't
# run correctly for cross-compiling
define PYTHON_PYCRYPTO_CONFIGURE_CMDS
	(cd $(@D) && \
	$(TARGET_CONFIGURE_OPTS) \
	$(TARGET_CONFIGURE_ARGS) \
	./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/usr \
		--sysconfdir=/etc \
		--program-prefix="" \
	)
endef

$(eval $(python-package))
