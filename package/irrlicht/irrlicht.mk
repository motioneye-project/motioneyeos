################################################################################
#
# irrlicht
#
################################################################################

IRRLICHT_VERSION_MAJOR = 1.8
IRRLICHT_VERSION = $(IRRLICHT_VERSION_MAJOR).4
IRRLICHT_SOURCE = irrlicht-$(IRRLICHT_VERSION).zip
IRRLICHT_SITE = https://downloads.sourceforge.net/project/irrlicht/Irrlicht%20SDK/$(IRRLICHT_VERSION_MAJOR)/$(IRRLICHT_VERSION)
IRRLICHT_INSTALL_STAGING = YES

# Bundled libraries: bzip2, libaesGladman, libpng, lzma, zlib,
# The handcrafted Makefile can only use bundled libraries.
IRRLICHT_LICENSE = Zlib (irrlicht), BSD-3-Clause (libaesGladman), bzip2-1.0.5 (bzip2), IJG (libjpeg), Libpng (libpng)
IRRLICHT_LICENSE_FILES = \
	doc/aesGladman.txt \
	doc/bzip2-license.txt \
	doc/irrlicht-license.txt \
	doc/jpglib-license.txt \
	doc/libpng-license.txt

IRRLICHT_SUBDIR = source/Irrlicht

IRRLICHT_DEPENDENCIES = libgl xlib_libXxf86vm

define IRRLICHT_EXTRACT_CMDS
	$(UNZIP) -d $(@D) $(IRRLICHT_DL_DIR)/$(IRRLICHT_SOURCE)
	mv $(@D)/irrlicht-$(IRRLICHT_VERSION)/* $(@D)
	$(RM) -r $(@D)/irrlicht-$(IRRLICHT_VERSION)
endef

IRRLICHT_CONF_OPTS = $(TARGET_CONFIGURE_OPTS)

# Build a static library OR a shared library, otherwise we need to compile with -fPIC
# "relocation R_X86_64_32S can not be used when making a shared object; recompile with -fPIC"
ifeq ($(BR2_STATIC_LIBS),)
IRRLICHT_CONF_OPTS += sharedlib
endif

# Irrlicht fail to detect properly the NEON support on aarch64 or ARM with NEON FPU support.
# While linking an application with libIrrlicht.so, we get an undefined reference to
# png_init_filter_functions_neon.
# Some files are missing in the libpng bundled in Irrlicht, in particular arm/arm_init.c,
# so disable NEON support completely.
IRRLICHT_CONF_OPTS += CPPFLAGS="$(TARGET_CPPFLAGS) -DPNG_ARM_NEON_OPT=0"

define IRRLICHT_BUILD_CMDS
	$(TARGET_MAKE_ENV)
		$(MAKE) -C $(@D)/$(IRRLICHT_SUBDIR) $(IRRLICHT_CONF_OPTS)
endef

define IRRLICHT_INSTALL_STAGING_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
		INSTALL_DIR=$(STAGING_DIR)/usr/lib \
		-C $(@D)/$(IRRLICHT_SUBDIR) install
endef

define IRRLICHT_INSTALL_TARGET_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) \
		INSTALL_DIR=$(TARGET_DIR)/usr/lib \
		-C $(@D)/$(IRRLICHT_SUBDIR) install
endef

$(eval $(generic-package))
