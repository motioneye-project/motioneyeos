################################################################################
#
# python-pyzmq
#
################################################################################

PYTHON_PYZMQ_VERSION = 13.1.0
PYTHON_PYZMQ_SOURCE = pyzmq-$(PYTHON_PYZMQ_VERSION).tar.gz
PYTHON_PYZMQ_SITE = http://pypi.python.org/packages/source/p/pyzmq/
PYTHON_PYZMQ_LICENSE = LGPLv3+ BSD-3c Apache-2.0
# Apache license only online: http://www.apache.org/licenses/LICENSE-2.0
PYTHON_PYZMQ_LICENSE_FILES = COPYING.LESSER COPYING.BSD
PYTHON_PYZMQ_DEPENDENCIES = zeromq
PYTHON_PYZMQ_SETUP_TYPE = distutils

# Due to issues with cross-compiling, hardcode to the zeromq in BR
define PYTHON_PYZMQ_PATCH_ZEROMQ_VERSION
	$(SED) 's/##ZEROMQ_VERSION##/$(ZEROMQ_VERSION)/' \
		$(@D)/buildutils/detect.py
endef

PYTHON_PYZMQ_POST_PATCH_HOOKS += PYTHON_PYZMQ_PATCH_ZEROMQ_VERSION

$(eval $(python-package))
