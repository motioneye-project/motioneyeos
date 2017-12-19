################################################################################
#
# qpid-proton
#
################################################################################

QPID_PROTON_VERSION = 0.9.1
QPID_PROTON_SITE = http://apache.panu.it/qpid/proton/$(QPID_PROTON_VERSION)
QPID_PROTON_STRIP_COMPONENTS = 2
QPID_PROTON_LICENSE = Apache-2.0
QPID_PROTON_LICENSE_FILES = LICENSE
QPID_PROTON_INSTALL_STAGING = YES
QPID_PROTON_DEPENDENCIES = \
	host-python \
	util-linux \
	$(if $(BR2_PACKAGE_OPENSSL),openssl)

# Language bindings are enabled when host-swig tool is present in HOST_DIR.
# For now, disable all of them.
QPID_PROTON_CONF_OPTS = \
	-DBUILD_JAVA=OFF \
	-DBUILD_JAVASCRIPT=OFF \
	-DBUILD_PERL=OFF \
	-DBUILD_PHP=OFF \
	-DBUILD_PYTHON=OFF \
	-DBUILD_RUBY=OFF \
	-DENABLE_VALGRIND=OFF \
	-DENABLE_WARNING_ERROR=OFF \
	-DPYTHON_EXECUTABLE=$(HOST_DIR)/bin/python2

define QPID_PROTON_REMOVE_USELESS_FILES
	rm -fr $(TARGET_DIR)/usr/share/proton-*/
endef

QPID_PROTON_POST_INSTALL_TARGET_HOOKS += QPID_PROTON_REMOVE_USELESS_FILES

$(eval $(cmake-package))
