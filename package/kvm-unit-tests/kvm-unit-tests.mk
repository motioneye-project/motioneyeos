################################################################################
#
# kvm-unit-tests
#
################################################################################

KVM_UNIT_TESTS_VERSION = kvm-unit-tests-20171020
KVM_UNIT_TESTS_SITE = $(BR2_KERNEL_MIRROR)/scm/virt/kvm/kvm-unit-tests.git
KVM_UNIT_TESTS_SITE_METHOD = git
KVM_UNIT_TESTS_LICENSE = LGPL-2.0
KVM_UNIT_TESTS_LICENSE_FILES = COPYRIGHT

ifeq ($(BR2_arm),y)
KVM_UNIT_TESTS_ARCH = arm
else ifeq ($(BR2_i386),y)
KVM_UNIT_TESTS_ARCH = i386
else ifeq ($(BR2_powerpc64)$(BR2_powerpc64le),y)
KVM_UNIT_TESTS_ARCH = ppc64
else ifeq ($(BR2_x86_64),y)
KVM_UNIT_TESTS_ARCH = x86_64
endif

ifeq ($(BR2_ENDIAN),"LITTLE")
KVM_UNIT_TESTS_ENDIAN = little
else
KVM_UNIT_TESTS_ENDIAN = big
endif

KVM_UNIT_TESTS_CONF_OPTS =\
	--arch="$(KVM_UNIT_TESTS_ARCH)" \
	--processor="$(GCC_TARGET_CPU)" \
	--endian="$(KVM_UNIT_TESTS_ENDIAN)"

# For all architectures but x86-64, we use the target
# compiler. However, for x86-64, we use the host compiler, as
# kvm-unit-tests builds 32 bit code, which Buildroot toolchains for
# x86-64 cannot do.
ifneq ($(BR2_x86_64),y)
KVM_UNIT_TESTS_CONF_OPTS += --cross-prefix="$(TARGET_CROSS)"
endif

define KVM_UNIT_TESTS_CONFIGURE_CMDS
	cd $(@D) && ./configure $(KVM_UNIT_TESTS_CONF_OPTS)
endef

define KVM_UNIT_TESTS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) standalone
endef

define KVM_UNIT_TESTS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) \
		DESTDIR=$(TARGET_DIR)/usr/share/kvm-unit-tests/ \
		install
endef

# Does use configure script but not an autotools one
$(eval $(generic-package))
