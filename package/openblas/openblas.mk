################################################################################
#
# openblas
#
################################################################################

OPENBLAS_VERSION = v0.2.20
OPENBLAS_SITE = $(call github,xianyi,OpenBLAS,$(OPENBLAS_VERSION))
OPENBLAS_LICENSE = BSD-3-Clause
OPENBLAS_LICENSE_FILES = LICENSE
OPENBLAS_INSTALL_STAGING = YES

# Initialise OpenBLAS make options to $(TARGET_CONFIGURE_OPTS)
OPENBLAS_MAKE_OPTS = $(TARGET_CONFIGURE_OPTS)

# Enable cross-compiling
OPENBLAS_MAKE_OPTS += CROSS=1

# Set OpenBLAS target
OPENBLAS_MAKE_OPTS += TARGET=$(BR2_PACKAGE_OPENBLAS_TARGET)

# When Fortran is not available, only build the C version of BLAS
ifeq ($(BR2_TOOLCHAIN_HAS_FORTRAN),)
OPENBLAS_MAKE_OPTS += ONLY_CBLAS=1
endif

# Enable/Disable multi-threading (not for static-only since it uses dlfcn.h)
ifeq ($(BR2_TOOLCHAIN_HAS_THREADS):$(BR2_STATIC_LIBS),y:)
OPENBLAS_MAKE_OPTS += USE_THREAD=1
else
OPENBLAS_MAKE_OPTS += USE_THREAD=0
endif

# We don't know if OpenMP is available or not, so disable
OPENBLAS_MAKE_OPTS += USE_OPENMP=0

# Static-only/Shared-only toggle
ifeq ($(BR2_STATIC_LIBS),y)
OPENBLAS_MAKE_OPTS += NO_SHARED=1
else ifeq ($(BR2_SHARED_LIBS),y)
OPENBLAS_MAKE_OPTS += NO_STATIC=1
endif

# binutils version <= 2.23.2 has a bug
# (https://sourceware.org/bugzilla/show_bug.cgi?id=14887) where
# whitespaces in ARM register specifications such as [ r1, #12 ] or [
# r2 ] cause the assembler to reject the code. Since there are
# numerous instances of such cases in the code, we use sed rather than
# a patch. We simply replace [ foobar ] by [foobar] to work around the
# problem.
define OPENBLAS_FIXUP_ARM_ASSEMBLY
	$(SED) 's%\[\s*%\[%;s%\s*\]%\]%' $(@D)/kernel/arm/*.S
endef

OPENBLAS_POST_PATCH_HOOKS += OPENBLAS_FIXUP_ARM_ASSEMBLY

define OPENBLAS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(OPENBLAS_MAKE_OPTS) \
		-C $(@D)
endef

define OPENBLAS_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(OPENBLAS_MAKE_OPTS) \
		-C $(@D) install PREFIX=$(STAGING_DIR)/usr
endef

define OPENBLAS_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(OPENBLAS_MAKE_OPTS) \
		-C $(@D) install PREFIX=$(TARGET_DIR)/usr
endef

$(eval $(generic-package))
