################################################################################
#
# nodejs
#
################################################################################

NODEJS_VERSION = 12.16.1
NODEJS_SOURCE = node-v$(NODEJS_VERSION).tar.xz
NODEJS_SITE = http://nodejs.org/dist/v$(NODEJS_VERSION)
NODEJS_DEPENDENCIES = host-python host-nodejs c-ares \
	libuv zlib nghttp2 \
	$(call qstrip,$(BR2_PACKAGE_NODEJS_MODULES_ADDITIONAL_DEPS))
HOST_NODEJS_DEPENDENCIES = host-libopenssl host-python host-zlib
NODEJS_LICENSE = MIT (core code); MIT, Apache and BSD family licenses (Bundled components)
NODEJS_LICENSE_FILES = LICENSE

NODEJS_CONF_OPTS = \
	--without-snapshot \
	--shared-zlib \
	--shared-cares \
	--shared-libuv \
	--shared-nghttp2 \
	--without-dtrace \
	--without-etw \
	--cross-compiling \
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

	(cd $(@D); \
		$(HOST_CONFIGURE_OPTS) \
		PATH=$(@D)/bin:$(BR_PATH) \
		PYTHON=$(HOST_DIR)/bin/python2 \
		$(HOST_DIR)/bin/python2 ./configure \
		--prefix=$(HOST_DIR) \
		--without-snapshot \
		--without-dtrace \
		--without-etw \
		--shared-openssl \
		--shared-openssl-includes=$(HOST_DIR)/include/openssl \
		--shared-openssl-libpath=$(HOST_DIR)/lib \
		--shared-zlib \
		--no-cross-compiling \
		--with-intl=small-icu \
	)
endef

NODEJS_HOST_TOOLS_V8 = \
	torque \
	gen-regexp-special-case \
	bytecode_builtins_list_generator
NODEJS_HOST_TOOLS_NODE = mkcodecache
NODEJS_HOST_TOOLS = $(NODEJS_HOST_TOOLS_V8) $(NODEJS_HOST_TOOLS_NODE)

define HOST_NODEJS_BUILD_CMDS
	$(HOST_MAKE_ENV) PYTHON=$(HOST_DIR)/bin/python2 \
		$(MAKE) -C $(@D) \
		$(HOST_CONFIGURE_OPTS) \
		LDFLAGS.host="$(HOST_LDFLAGS)" \
		NO_LOAD=cctest.target.mk \
		PATH=$(@D)/bin:$(BR_PATH)
endef

define HOST_NODEJS_INSTALL_CMDS
	$(HOST_MAKE_ENV) PYTHON=$(HOST_DIR)/bin/python2 \
		$(MAKE) -C $(@D) install \
		$(HOST_CONFIGURE_OPTS) \
		LDFLAGS.host="$(HOST_LDFLAGS)" \
		NO_LOAD=cctest.target.mk \
		PATH=$(@D)/bin:$(BR_PATH)

	$(foreach f,$(NODEJS_HOST_TOOLS), \
		$(INSTALL) -m755 -D $(@D)/out/Release/$(f) $(HOST_DIR)/bin/$(f)
	)
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
# V8 needs to know what floating point ABI the target is using.
NODEJS_ARM_FP = $(GCC_TARGET_FLOAT_ABI)
# it also wants to know which FPU to use, but only has support for
# vfp, vfpv3, vfpv3-d16 and neon.
ifeq ($(BR2_ARM_FPU_VFPV2),y)
NODEJS_ARM_FPU = vfp
# vfpv4 is a superset of vfpv3
else ifeq ($(BR2_ARM_FPU_VFPV3)$(BR2_ARM_FPU_VFPV4),y)
NODEJS_ARM_FPU = vfpv3
# vfpv4-d16 is a superset of vfpv3-d16
else ifeq ($(BR2_ARM_FPU_VFPV3D16)$(BR2_ARM_FPU_VFPV4D16),y)
NODEJS_ARM_FPU = vfpv3-d16
else ifeq ($(BR2_ARM_FPU_NEON),y)
NODEJS_ARM_FPU = neon
endif
else ifeq ($(BR2_aarch64),y)
NODEJS_CPU = arm64
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

NODEJS_LDFLAGS = $(TARGET_LDFLAGS)

ifeq ($(BR2_TOOLCHAIN_HAS_LIBATOMIC),y)
NODEJS_LDFLAGS += -latomic
endif

define NODEJS_CONFIGURE_CMDS
	mkdir -p $(@D)/bin
	ln -sf $(HOST_DIR)/bin/python2 $(@D)/bin/python

	(cd $(@D); \
		$(TARGET_CONFIGURE_OPTS) \
		PATH=$(@D)/bin:$(BR_PATH) \
		LDFLAGS="$(NODEJS_LDFLAGS)" \
		LD="$(TARGET_CXX)" \
		PYTHON=$(HOST_DIR)/bin/python2 \
		$(HOST_DIR)/bin/python2 ./configure \
		--prefix=/usr \
		--dest-cpu=$(NODEJS_CPU) \
		$(if $(NODEJS_ARM_FP),--with-arm-float-abi=$(NODEJS_ARM_FP)) \
		$(if $(NODEJS_ARM_FPU),--with-arm-fpu=$(NODEJS_ARM_FPU)) \
		$(if $(NODEJS_MIPS_ARCH_VARIANT),--with-mips-arch-variant=$(NODEJS_MIPS_ARCH_VARIANT)) \
		$(if $(NODEJS_MIPS_FPU_MODE),--with-mips-fpu-mode=$(NODEJS_MIPS_FPU_MODE)) \
		$(NODEJS_CONF_OPTS) \
	)

	$(foreach f,$(NODEJS_HOST_TOOLS_V8), \
		$(SED) "s#<(PRODUCT_DIR)/<(EXECUTABLE_PREFIX)$(f)<(EXECUTABLE_SUFFIX)#$(HOST_DIR)/bin/$(f)#" \
			$(@D)/tools/v8_gypfiles/v8.gyp
	)
	$(foreach f,$(NODEJS_HOST_TOOLS_NODE), \
		$(SED) "s#<(PRODUCT_DIR)/<(EXECUTABLE_PREFIX)$(f)<(EXECUTABLE_SUFFIX)#$(HOST_DIR)/bin/$(f)#" \
			-i $(@D)/node.gyp
	)
endef

define NODEJS_BUILD_CMDS
	$(TARGET_MAKE_ENV) PYTHON=$(HOST_DIR)/bin/python2 \
		$(MAKE) -C $(@D) \
		$(TARGET_CONFIGURE_OPTS) \
		NO_LOAD=cctest.target.mk \
		PATH=$(@D)/bin:$(BR_PATH) \
		LDFLAGS="$(NODEJS_LDFLAGS)" \
		LD="$(TARGET_CXX)"
endef

#
# Build the list of modules to install.
#
NODEJS_MODULES_LIST= $(call qstrip,\
	$(BR2_PACKAGE_NODEJS_MODULES_ADDITIONAL))

# Define NPM for other packages to use
NPM = $(TARGET_CONFIGURE_OPTS) \
	LDFLAGS="$(NODEJS_LDFLAGS)" \
	LD="$(TARGET_CXX)" \
	npm_config_arch=$(NODEJS_CPU) \
	npm_config_target_arch=$(NODEJS_CPU) \
	npm_config_build_from_source=true \
	npm_config_nodedir=$(BUILD_DIR)/nodejs-$(NODEJS_VERSION) \
	npm_config_prefix=$(TARGET_DIR)/usr \
	npm_config_cache=$(BUILD_DIR)/.npm-cache \
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
		LDFLAGS="$(NODEJS_LDFLAGS)" \
		LD="$(TARGET_CXX)"
	$(NODEJS_INSTALL_MODULES)
endef

# node.js configure is a Python script and does not use autotools
$(eval $(generic-package))
$(eval $(host-generic-package))
