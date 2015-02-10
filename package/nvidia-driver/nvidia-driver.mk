################################################################################
#
# nvidia-driver
#
################################################################################

NVIDIA_DRIVER_VERSION = 346.35
NVIDIA_DRIVER_SUFFIX = $(if $(BR2_x86_64),_64)
NVIDIA_DRIVER_SITE = ftp://download.nvidia.com/XFree86/Linux-x86$(NVIDIA_DRIVER_SUFFIX)/$(NVIDIA_DRIVER_VERSION)
NVIDIA_DRIVER_SOURCE = NVIDIA-Linux-x86$(NVIDIA_DRIVER_SUFFIX)-$(NVIDIA_DRIVER_VERSION).run
NVIDIA_DRIVER_LICENSE = NVIDIA Software License
NVIDIA_DRIVER_LICENSE_FILES = LICENSE
NVIDIA_DRIVER_REDISTRIBUTE = NO
NVIDIA_DRIVER_INSTALL_STAGING = YES

# Since nvidia-driver are binary blobs, the below dependencies are not
# strictly speaking build dependencies of nvidia-driver. However, they
# are build dependencies of packages that depend on nvidia-driver, so
# they should be built prior to those packages, and the only simple
# way to do so is to make nvidia-driver depend on them.
NVIDIA_DRIVER_DEPENDENCIES = mesa3d-headers xlib_libX11 xlib_libXext
NVIDIA_DRIVER_PROVIDES = libgl libegl libgles

# We have two variables that contains a list of libraries to install:
#   NVIDIA_DRIVER_LIBS
#       contains the libraries whose filename end up in .so.$(VERSION); rather
#       than duplicate the version string for all of them, we just store their
#       basename, and append the version string below.
#   NVIDIA_DRIVER_LIBS_NO_VERSION
#       contains all libraries the do not use the NVidia version; since there
#       is currently only one such library, we store its full name.

# Each line corresponds to a specific set of libraries
NVIDIA_DRIVER_LIBS = \
	libEGL libGLESv1_CM libGLESv2 libGL \
	libnvidia-glcore libnvidia-eglcore libnvidia-glsi \
	tls/libnvidia-tls \
	libvdpau libvdpau_nvidia \
	libnvidia-ml

ifeq ($(BR2_PACKAGE_NVIDIA_DRIVER_CUDA),y)
NVIDIA_DRIVER_LIBS += libcuda libnvidia-compiler libnvcuvid libnvidia-encode
endif

ifeq ($(BR2_PACKAGE_NVIDIA_DRIVER_OPENCL),y)
NVIDIA_DRIVER_LIBS_NO_VERSION += libOpenCL.so.1.0.0
NVIDIA_DRIVER_LIBS += libnvidia-opencl
endif

# Those libraries are 'private' libraries requiring an agreement with
# NVidia to develop code for those libs. There seems to be no restriction
# on using those libraries (e.g. if the user has such an agreement, or
# wants to run a third-party program developped under such an agreement).
ifeq ($(BR2_PACKAGE_NVIDIA_DRIVER_PRIVATE_LIBS),y)
NVIDIA_DRIVER_LIBS += libnvidia-ifr libnvidia-fbc
endif

# We refer to the destination path; the origin file has no directory component
NVIDIA_DRIVER_X_MODS = drivers/nvidia_drv.so \
	extensions/libglx.so.$(NVIDIA_DRIVER_VERSION) \
	libnvidia-wfb.so.$(NVIDIA_DRIVER_VERSION)

# The downloaded archive is in fact an auto-extract script. So, it can run
# virtually everywhere, and it is fine enough to provide useful options.
# Except it can't extract into an existing (even empty) directory.
define NVIDIA_DRIVER_EXTRACT_CMDS
	$(SHELL) $(DL_DIR)/$(NVIDIA_DRIVER_SOURCE) --extract-only --target \
		$(@D)/tmp-extract
	mv $(@D)/tmp-extract/* $(@D)/tmp-extract/.manifest $(@D)
	rm -rf $(@D)/tmp-extract
endef

# Helper to install libraries
# $1: destination directory (target or staging)
#
# For all libraries that need it, we append the NVidia version string.
# Then for all libraries, we install them and create a symlink using
# their SONAME, so we can link to them at runtime; we also create the
# no-version symlink, so we can link to them at build time.
define NVIDIA_DRIVER_INSTALL_LIBS
	for libpath in $(addsuffix .so.$(NVIDIA_DRIVER_VERSION),$(NVIDIA_DRIVER_LIBS)) \
	           $(NVIDIA_DRIVER_LIBS_NO_VERSION); \
	do \
		libname="$${libpath##*/}"; \
		$(INSTALL) -D -m 0644 $(@D)/$${libpath} $(1)/usr/lib/$${libname}; \
		libsoname="$$( $(TARGET_READELF) -d "$(@D)/$${libpath}" \
		       |sed -r -e '/.*\(SONAME\).*\[(.*)\]$$/!d; s//\1/;' )"; \
		if [ -n "$${libsoname}" -a "$${libsoname}" != "$${libname}" ]; then \
			ln -sf $${libname} $(1)/usr/lib/$${libsoname}; \
		fi; \
		baseso="$${libname/.so*}.so"; \
		if [ -n "$${baseso}" -a "$${baseso}" != "$${libname}" ]; then \
			ln -sf $${libname} $(1)/usr/lib/$${baseso}; \
		fi; \
	done
endef

# For staging, install libraries and development files
define NVIDIA_DRIVER_INSTALL_STAGING_CMDS
	$(call NVIDIA_DRIVER_INSTALL_LIBS,$(STAGING_DIR))
	$(INSTALL) -D -m 0644 $(@D)/libGL.la $(STAGING_DIR)/usr/lib/libGL.la
	$(SED) 's:__GENERATED_BY__:Buildroot:' $(STAGING_DIR)/usr/lib/libGL.la
	$(SED) 's:__LIBGL_PATH__:/usr/lib:' $(STAGING_DIR)/usr/lib/libGL.la
	$(SED) 's:-L[^[:space:]]\+::' $(STAGING_DIR)/usr/lib/libGL.la
endef

# For target, install libraries and X.org modules
define NVIDIA_DRIVER_INSTALL_TARGET_CMDS
	$(call NVIDIA_DRIVER_INSTALL_LIBS,$(TARGET_DIR))
	for m in $(NVIDIA_DRIVER_X_MODS); do \
		$(INSTALL) -D -m 0644 $(@D)/$${m##*/} \
			$(TARGET_DIR)/usr/lib/xorg/modules/$${m}; \
	done
endef

$(eval $(generic-package))
