################################################################################
#
# nodejs
#
################################################################################

NODEJS_VERSION = 8.1.2
NODEJS_SOURCE = node-v$(NODEJS_VERSION).tar.xz
NODEJS_SITE = http://nodejs.org/dist/v$(NODEJS_VERSION)
NODEJS_DEPENDENCIES = host-python host-nodejs zlib \
	$(call qstrip,$(BR2_PACKAGE_NODEJS_MODULES_ADDITIONAL_DEPS))
HOST_NODEJS_DEPENDENCIES = host-python host-zlib
NODEJS_LICENSE = MIT (core code); MIT, Apache and BSD family licenses (Bundled components)
NODEJS_LICENSE_FILES = LICENSE

NODEJS_CONF_OPTS = \
	--without-snapshot \
	--shared-zlib \
	--without-dtrace \
	--without-etw \
	--dest-os=linux

ifeq ($(BR2_PACKAGE_OPENSSL),y)
NODEJS_DEPENDENCIES += openssl
NODEJS_CONF_OPTS += --shared-openssl
else
NODEJS_CONF_OPTS += --without-ssl
endif

ifeq ($(BR2_PACKAGE_ICU),y)
NODEJS_DEPENDENCIES += icu
NODEJS_CONF_OPTS += --with-intl=system-icu
else
NODEJS_CONF_OPTS += --with-intl=none
endif

ifneq ($(BR2_PACKAGE_NODEJS_NPM),y)
NODEJS_CONF_OPTS += --without-npm
endif

# nodejs build system is based on python, but only support python-2.6 or
# python-2.7. So, we have to enforce PYTHON interpreter to be python2.
define HOST_NODEJS_CONFIGURE_CMDS
	# The build system directly calls python. Work around this by forcing python2
	# into PATH. See https://github.com/nodejs/node/issues/2735
	mkdir -p $(@D)/bin
	ln -sf $(HOST_DIR)/bin/python2 $(@D)/bin/python

	# Build with the static, built-in OpenSSL which is supplied as part of
	# the nodejs source distribution.  This is needed on the host because
	# NPM is non-functional without it, and host-openssl isn't part of
	# buildroot.
	(cd $(@D); \
		$(HOST_CONFIGURE_OPTS) \
		PATH=$(@D)/bin:$(BR_PATH) \
		PYTHON=$(HOST_DIR)/bin/python2 \
		$(HOST_DIR)/bin/python2 ./configure \
		--prefix=$(HOST_DIR) \
		--without-snapshot \
		--without-dtrace \
		--without-etw \
		--shared-zlib \
		--with-intl=none \
	)
endef

define HOST_NODEJS_BUILD_CMDS
	$(HOST_MAKE_ENV) PYTHON=$(HOST_DIR)/bin/python2 \
		$(MAKE) -C $(@D) \
		$(HOST_CONFIGURE_OPTS) \
		NO_LOAD=cctest.target.mk \
		PATH=$(@D)/bin:$(BR_PATH)
endef

define HOST_NODEJS_INSTALL_CMDS
	$(HOST_MAKE_ENV) PYTHON=$(HOST_DIR)/bin/python2 \
		$(MAKE) -C $(@D) install \
		$(HOST_CONFIGURE_OPTS) \
		NO_LOAD=cctest.target.mk \
		PATH=$(@D)/bin:$(BR_PATH)

	$(INSTALL) -m755 -D $(@D)/out/Release/mkpeephole $(HOST_DIR)/bin/mkpeephole
endef

ifeq ($(BR2_i386),y)
NODEJS_CPU = ia32
else ifeq ($(BR2_x86_64),y)
NODEJS_CPU = x64
else ifeq ($(BR2_mips),y)
NODEJS_CPU = mips
else ifeq ($(BR2_mipsel),y)
NODEJS_CPU = mipsel
else ifeq ($(BR2_arm),y)
NODEJS_CPU = arm
else ifeq ($(BR2_aarch64),y)
NODEJS_CPU = arm64
# V8 needs to know what floating point ABI the target is using.
NODEJS_ARM_FP = $(call qstrip,$(BR2_GCC_TARGET_FLOAT_ABI))
endif

# MIPS architecture specific options
ifeq ($(BR2_mips)$(BR2_mipsel),y)
ifeq ($(BR2_MIPS_CPU_MIPS32R6),y)
NODEJS_MIPS_ARCH_VARIANT = r6
NODEJS_MIPS_FPU_MODE = fp64
else ifeq ($(BR2_MIPS_CPU_MIPS32R2),y)
NODEJS_MIPS_ARCH_VARIANT = r2
else ifeq ($(BR2_MIPS_CPU_MIPS32),y)
NODEJS_MIPS_ARCH_VARIANT = r1
endif
endif

define NODEJS_CONFIGURE_CMDS
	mkdir -p $(@D)/bin
	ln -sf $(HOST_DIR)/bin/python2 $(@D)/bin/python

	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		PATH=$(@D)/bin:$(BR_PATH) \
		LD="$(TARGET_CXX)" \
		PYTHON=$(HOST_DIR)/bin/python2 \
		$(HOST_DIR)/bin/python2 ./configure \
		--prefix=/usr \
		--dest-cpu=$(NODEJS_CPU) \
		$(if $(NODEJS_ARM_FP),--with-arm-float-abi=$(NODEJS_ARM_FP)) \
		$(if $(NODEJS_MIPS_ARCH_VARIANT),--with-mips-arch-variant=$(NODEJS_MIPS_ARCH_VARIANT)) \
		$(if $(NODEJS_MIPS_FPU_MODE),--with-mips-fpu-mode=$(NODEJS_MIPS_FPU_MODE)) \
		$(NODEJS_CONF_OPTS) \
	)

	# use host version of mkpeephole
	sed "s#<(mkpeephole_exec)#$(HOST_DIR)/bin/mkpeephole#g" -i $(@D)/deps/v8/src/v8.gyp
endef

define NODEJS_BUILD_CMDS
	$(TARGET_MAKE_ENV) PYTHON=$(HOST_DIR)/bin/python2 \
		$(MAKE) -C $(@D) \
		$(TARGET_CONFIGURE_OPTS) \
		NO_LOAD=cctest.target.mk \
		PATH=$(@D)/bin:$(BR_PATH) \
		LD="$(TARGET_CXX)"
endef

#
# Build the list of modules to install.
#
NODEJS_MODULES_LIST= $(call qstrip,\
	$(BR2_PACKAGE_NODEJS_MODULES_ADDITIONAL))

# Define NPM for other packages to use
NPM = $(TARGET_CONFIGURE_OPTS) \
	LD="$(TARGET_CXX)" \
	npm_config_arch=$(NODEJS_CPU) \
	npm_config_target_arch=$(NODEJS_CPU) \
	npm_config_build_from_source=true \
	npm_config_nodedir=$(BUILD_DIR)/nodejs-$(NODEJS_VERSION) \
	npm_config_prefix=$(TARGET_DIR)/usr \
	$(HOST_DIR)/bin/npm

#
# We can only call NPM if there's something to install.
#
ifneq ($(NODEJS_MODULES_LIST),)
define NODEJS_INSTALL_MODULES
	# If you're having trouble with module installation, adding -d to the
	# npm install call below and setting npm_config_rollback=false can both
	# help in diagnosing the problem.
	$(NPM) install -g $(NODEJS_MODULES_LIST)
endef
endif

define NODEJS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) PYTHON=$(HOST_DIR)/bin/python2 \
		$(MAKE) -C $(@D) install \
		DESTDIR=$(TARGET_DIR) \
		$(TARGET_CONFIGURE_OPTS) \
		NO_LOAD=cctest.target.mk \
		PATH=$(@D)/bin:$(BR_PATH) \
		LD="$(TARGET_CXX)"
	$(NODEJS_INSTALL_MODULES)
endef

# node.js configure is a Python script and does not use autotools
$(eval $(generic-package))
$(eval $(host-generic-package))
