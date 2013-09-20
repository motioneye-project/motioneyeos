################################################################################
#
# python-pyzmq
#
################################################################################

PYTHON_PYZMQ_VERSION = 13.1.0
PYTHON_PYZMQ_SOURCE = pyzmq-$(PYTHON_PYZMQ_VERSION).tar.gz
PYTHON_PYZMQ_SITE = http://pypi.python.org/packages/source/p/pyzmq/
PYTHON_PYZMQ_LICENSE = LGPLv3+ BSD-3c Apache License Version 2.0
# Apache license only online: http://www.apache.org/licenses/LICENSE-2.0
PYTHON_PYZMQ_LICENSE_FILES = COPYING.LESSER COPYING.BSD
PYTHON_PYZMQ_DEPENDENCIES = zeromq python host-python

# Due to issues with cross-compiling, hardcode to the zeromq in BR
define PYTHON_PYZMQ_PATCH_ZEROMQ_VERSION
	$(SED) 's/##ZEROMQ_VERSION##/$(ZEROMQ_VERSION)/' \
		$(@D)/buildutils/detect.py
endef

PYTHON_PYZMQ_POST_PATCH_HOOKS += PYTHON_PYZMQ_PATCH_ZEROMQ_VERSION

PYTHON_PYZMQ_PARAMS = CC="$(TARGET_CC)" \
		CFLAGS="$(TARGET_CFLAGS)" \
		LDSHARED="$(TARGET_CC) -shared" \
		CROSS_COMPILING=yes \
		_python_sysroot=$(STAGING_DIR) \
		_python_srcdir=$(PYTHON_DIR) \
		_python_prefix=/usr \
		_python_exec_prefix=/usr

define PYTHON_PYZMQ_CONFIGURE_CMDS
	(cd $(@D); $(PYTHON_PYZMQ_PARAMS) \
		$(HOST_DIR)/usr/bin/python setup.py configure \
		--zmq=$(STAGING_DIR)/usr)
endef

define PYTHON_PYZMQ_INSTALL_TARGET_CMDS
	(cd $(@D); $(PYTHON_PYZMQ_PARAMS) \
		$(HOST_DIR)/usr/bin/python setup.py install \
		--prefix=$(TARGET_DIR)/usr)
endef

$(eval $(generic-package))
