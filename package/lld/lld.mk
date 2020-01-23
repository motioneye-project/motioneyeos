################################################################################
#
# lld
#
################################################################################

# LLVM, Clang and lld should be version bumped together
LLD_VERSION = 9.0.1
LLD_SITE = https://github.com/llvm/llvm-project/releases/download/llvmorg-$(LLD_VERSION)
LLD_SOURCE = lld-$(LLD_VERSION).src.tar.xz
LLD_LICENSE = Apache-2.0 with exceptions
LLD_LICENSE_FILES = LICENSE.TXT
LLD_SUPPORTS_IN_SOURCE_BUILD = NO
HOST_LLD_DEPENDENCIES = host-llvm

# LLVM > 9.0 will soon require C++14 support, building llvm <= 9.0 using a
# toolchain using gcc < 5.1 gives an error but actually still works. Setting
# this option makes it still build with gcc >= 4.8.
# https://reviews.llvm.org/D57264
HOST_LLD_CONF_OPTS += -DLLVM_TEMPORARILY_ALLOW_OLD_TOOLCHAIN=ON

# GCC looks for tools in a different path from LLD's default installation path
define HOST_LLD_CREATE_SYMLINKS
	mkdir -p $(HOST_DIR)/$(GNU_TARGET_NAME)/bin
	ln -sf $(HOST_DIR)/bin/lld $(HOST_DIR)/$(GNU_TARGET_NAME)/bin/lld
	ln -sf $(HOST_DIR)/bin/lld $(HOST_DIR)/$(GNU_TARGET_NAME)/bin/ld.lld
endef

HOST_LLD_POST_INSTALL_HOOKS += HOST_LLD_CREATE_SYMLINKS

$(eval $(host-cmake-package))
