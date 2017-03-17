################################################################################
#
# rt-tests
#
################################################################################

RT_TESTS_SITE = $(BR2_KERNEL_MIRROR)/linux/utils/rt-tests
RT_TESTS_SOURCE = rt-tests-$(RT_TESTS_VERSION).tar.xz
RT_TESTS_VERSION = 1.0
RT_TESTS_LICENSE = GPLv2+
RT_TESTS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_PYTHON),y)
RT_TESTS_DEPENDENCIES = python
endif

define RT_TESTS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)	\
		CC="$(TARGET_CC)" 		\
		CFLAGS="$(TARGET_CFLAGS)"	\
		prefix=/usr
endef

define RT_TESTS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D)		\
		DESTDIR="$(TARGET_DIR)" 		\
		prefix=/usr 				\
		$(if $(BR2_PACKAGE_PYTHON),PYLIB=/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages/,PYLIB="") \
		install
endef

$(eval $(generic-package))
