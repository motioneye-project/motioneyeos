################################################################################
#
# clang
#
################################################################################

CLANG_VERSION = 7.0.0
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

HOST_CLANG_CONF_OPTS += -DLLVM_CONFIG:FILEPATH=$(HOST_DIR)/bin/llvm-config \
	-DCLANG_DEFAULT_LINKER=$(TARGET_LD)
CLANG_CONF_OPTS += -DLLVM_CONFIG:FILEPATH=$(STAGING_DIR)/usr/bin/llvm-config \
	-DCLANG_TABLEGEN:FILEPATH=$(HOST_DIR)/bin/clang-tblgen \
	-DLLVM_TABLEGEN_EXE:FILEPATH=$(HOST_DIR)/bin/llvm-tblgen

# Clang can't be used as compiler on the target since there are no
# development files (headers) and other build tools. So remove clang
# binaries and some other unnecessary files from target.
CLANG_FILES_TO_REMOVE = \
	/usr/bin/clang* \
	/usr/bin/c-index-test \
	/usr/bin/git-clang-format \
	/usr/bin/scan-build \
	/usr/bin/scan-view \
	/usr/libexec/c++-analyzer \
	/usr/libexec/ccc-analyzer \
	/usr/share/clang \
	/usr/share/opt-viewer \
	/usr/share/scan-build \
	/usr/share/scan-view \
	/usr/share/man/man1/scan-build.1 \
	/usr/lib/clang

define CLANG_CLEANUP_TARGET
	rm -rf $(addprefix $(TARGET_DIR),$(CLANG_FILES_TO_REMOVE))
endef
CLANG_POST_INSTALL_TARGET_HOOKS += CLANG_CLEANUP_TARGET

# clang-tblgen is not installed by default, however it is necessary
# for cross-compiling clang
define HOST_CLANG_INSTALL_CLANG_TBLGEN
	$(INSTALL) -D -m 0755 $(HOST_CLANG_BUILDDIR)/bin/clang-tblgen \
		$(HOST_DIR)/bin/clang-tblgen
endef
HOST_CLANG_POST_INSTALL_HOOKS = HOST_CLANG_INSTALL_CLANG_TBLGEN

# This option must be enabled to link libclang dynamically against libLLVM.so
HOST_CLANG_CONF_OPTS += -DLLVM_LINK_LLVM_DYLIB=ON
CLANG_CONF_OPTS += -DLLVM_LINK_LLVM_DYLIB=ON

# Prevent clang binaries from linking against LLVM static libs
HOST_CLANG_CONF_OPTS += -DLLVM_DYLIB_COMPONENTS=all
CLANG_CONF_OPTS += -DLLVM_DYLIB_COMPONENTS=all

$(eval $(cmake-package))
$(eval $(host-cmake-package))
