################################################################################
#
# rt-tests
#
################################################################################

RT_TESTS_SITE = git://git.kernel.org/pub/scm/linux/kernel/git/clrkwllms/rt-tests.git
RT_TESTS_VERSION = v0.89
RT_TESTS_LICENSE = GPLv2+
RT_TESTS_LICENSE_FILES = COPYING

ifeq ($(BR2_PACKAGE_PYTHON),y)
RT_TESTS_DEPENDENCIES = python
endif

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS_NPTL),)
RT_TESTS_HAVE_NPTL=no
endif

define RT_TESTS_BUILD_CMDS
	$(MAKE) -C $(@D) 			\
		CC="$(TARGET_CC)" 		\
		HAVE_NPTL=$(RT_TESTS_HAVE_NPTL)	\
		CFLAGS="$(TARGET_CFLAGS)"	\
		prefix=/usr
endef

define RT_TESTS_INSTALL_TARGET_CMDS
	$(MAKE) -C $(@D) 				\
		HAVE_NPTL=$(RT_TESTS_HAVE_NPTL)		\
		DESTDIR="$(TARGET_DIR)" 		\
		prefix=/usr 				\
		$(if $(BR2_PACKAGE_PYTHON),HASPYTHON=1 PYLIB=/usr/lib/python$(PYTHON_VERSION_MAJOR)/site-packages/) \
		install
endef

$(eval $(generic-package))
