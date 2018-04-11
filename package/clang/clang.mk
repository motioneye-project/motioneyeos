################################################################################
#
# clang
#
################################################################################

CLANG_VERSION = 5.0.1
CLANG_SITE = http://llvm.org/releases/$(CLANG_VERSION)
CLANG_SOURCE = cfe-$(CLANG_VERSION).src.tar.xz
CLANG_LICENSE = NCSA
CLANG_LICENSE_FILES = LICENSE.TXT
CLANG_SUPPORTS_IN_SOURCE_BUILD = NO
CLANG_INSTALL_STAGING = YES

HOST_CLANG_DEPENDENCIES = host-llvm host-libxml2
CLANG_DEPENDENCIES = llvm host-clang

# This option is needed, otherwise multiple shared libs
# (libclangAST.so, libclangBasic.so, libclangFrontend.so, etc.) will
# be generated. As a final shared lib containing all these components
# (libclang.so) is also generated, this resulted in the following
# error when trying to use tools that use libclang:
# $ CommandLine Error: Option 'track-memory' registered more than once!
# $ LLVM ERROR: inconsistency in registered CommandLine options
# By setting BUILD_SHARED_LIBS to OFF, we generate multiple static
# libraries (the same way as host's clang build) and finally
# libclang.so to be installed on the target.
CLANG_CONF_OPTS += -DBUILD_SHARED_LIBS=OFF

# Default is Debug build, which requires considerably more disk space
# and build time. Release build is selected for host and target
# because the linker can run out of memory in Debug mode.
HOST_CLANG_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release
CLANG_CONF_OPTS += -DCMAKE_BUILD_TYPE=Release

CLANG_CONF_OPTS += -DCMAKE_CROSSCOMPILING=1

# We need to build tools because libclang is a tool
HOST_CLANG_CONF_OPTS += -DCLANG_BUILD_TOOLS=ON
CLANG_CONF_OPTS += -DCLANG_BUILD_TOOLS=ON

HOST_CLANG_CONF_OPTS += \
	-DCLANG_BUILD_EXAMPLES=OFF \
	-DCLANG_INCLUDE_DOCS=OFF \
	-DCLANG_INCLUDE_TESTS=OFF

CLANG_CONF_OPTS += \
	-DCLANG_BUILD_EXAMPLES=OFF \
	-DCLANG_INCLUDE_DOCS=OFF \
	-DCLANG_INCLUDE_TESTS=OFF

HOST_CLANG_CONF_OPTS += -DLLVM_CONFIG:FILEPATH=$(HOST_DIR)/bin/llvm-config
CLANG_CONF_OPTS += -DLLVM_CONFIG:FILEPATH=$(STAGING_DIR)/usr/bin/llvm-config \
	-DCLANG_TABLEGEN:FILEPATH=$(HOST_DIR)/usr/bin/clang-tblgen \
	-DLLVM_TABLEGEN_EXE:FILEPATH=$(HOST_DIR)/usr/bin/llvm-tblgen

# Clang can't be used as compiler on the target since there are no
# development files (headers) and other build tools. So remove clang
# binaries from target.
define CLANG_DELETE_BINARIES_FROM_TARGET
	rm -f $(TARGET_DIR)/usr/bin/clang*
endef
CLANG_POST_INSTALL_TARGET_HOOKS += CLANG_DELETE_BINARIES_FROM_TARGET

# clang-tblgen is not installed by default, however it is necessary
# for cross-compiling clang
define HOST_CLANG_INSTALL_CLANG_TBLGEN
	$(INSTALL) -D -m 0755 $(HOST_CLANG_BUILDDIR)/bin/clang-tblgen \
		$(HOST_DIR)/usr/bin/clang-tblgen
endef
HOST_CLANG_POST_INSTALL_HOOKS = HOST_CLANG_INSTALL_CLANG_TBLGEN

$(eval $(cmake-package))
$(eval $(host-cmake-package))
