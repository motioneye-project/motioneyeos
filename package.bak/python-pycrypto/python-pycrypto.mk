################################################################################
#
# python-pycrypto
#
################################################################################

PYTHON_PYCRYPTO_VERSION = 2.6.1
PYTHON_PYCRYPTO_SOURCE = pycrypto-$(PYTHON_PYCRYPTO_VERSION).tar.gz
PYTHON_PYCRYPTO_SITE = http://ftp.dlitz.net/pub/dlitz/crypto/pycrypto
PYTHON_PYCRYPTO_SETUP_TYPE = distutils

PYTHON_PYCRYPTO_LICENSE = Public Domain, Python 2.2 License (HMAC.py, setup.py)
PYTHON_PYCRYPTO_LICENSE_FILES = \
	COPYRIGHT LEGAL/copy/LICENSE.libtom \
	LEGAL/copy/LICENSE.python-2.2

# The pycrypto package contains a LICENSE.orig file, but our patching
# infrastrucure removes all .orig file, so we must rename that license
# file prior to patching, so it is still available to the legal-info
# infrastructure
define PYTHON_PYCRYPTO_RENAME_LICENSE
	mv $(@D)/LEGAL/copy/LICENSE.orig $(@D)/LEGAL/copy/LICENSE.original
endef
PYTHON_PYCRYPTO_POST_EXTRACT_HOOKS += PYTHON_PYCRYPTO_RENAME_LICENSE
HOST_PYTHON_PYCRYPTO_POST_EXTRACT_HOOKS += PYTHON_PYCRYPTO_RENAME_LICENSE
PYTHON_PYCRYPTO_LICENSE_FILES += LEGAL/copy/LICENSE.original

PYTHON_PYCRYPTO_DEPENDENCIES = gmp
HOST_PYTHON_PYCRYPTO_DEPENDENCIES = host-gmp

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
$(eval $(host-python-package))
