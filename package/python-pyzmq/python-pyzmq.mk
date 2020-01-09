################################################################################
#
# python-pyzmq
#
################################################################################

PYTHON_PYZMQ_VERSION = 18.1.1
PYTHON_PYZMQ_SOURCE = pyzmq-$(PYTHON_PYZMQ_VERSION).tar.gz
PYTHON_PYZMQ_SITE = https://files.pythonhosted.org/packages/3c/83/7ecbe9b762829f589fa9734026e0ccb63cb128fe5615ae1698f65df72bfe
PYTHON_PYZMQ_LICENSE = LGPL-3.0+, BSD-3-Clause, Apache-2.0
# Apache license only online: http://www.apache.org/licenses/LICENSE-2.0
PYTHON_PYZMQ_LICENSE_FILES = COPYING.LESSER COPYING.BSD
PYTHON_PYZMQ_DEPENDENCIES = zeromq
PYTHON_PYZMQ_SETUP_TYPE = distutils
PYTHON_PYZMQ_BUILD_OPTS = --zmq=$(STAGING_DIR)/usr

# Due to issues with cross-compiling, hardcode to the zeromq in BR
define PYTHON_PYZMQ_PATCH_ZEROMQ_VERSION
	$(SED) 's/##ZEROMQ_VERSION##/$(ZEROMQ_VERSION)/' \
		$(@D)/buildutils/detect.py
endef

PYTHON_PYZMQ_POST_PATCH_HOOKS += PYTHON_PYZMQ_PATCH_ZEROMQ_VERSION

ifeq ($(BR2_PACKAGE_ZEROMQ_DRAFTS),y)
PYTHON_PYZMQ_BUILD_OPTS += --enable-drafts
endif

$(eval $(python-package))
