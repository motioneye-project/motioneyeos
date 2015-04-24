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

ifeq ($(BR2_PACKAGE_NVIDIA_DRIVER_XORG),y)

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

# Install the gl.pc file
define NVIDIA_DRIVER_INSTALL_GL_DEV
	$(INSTALL) -D -m 0644 $(@D)/libGL.la $(STAGING_DIR)/usr/lib/libGL.la
	$(SED) 's:__GENERATED_BY__:Buildroot:' $(STAGING_DIR)/usr/lib/libGL.la
	$(SED) 's:__LIBGL_PATH__:/usr/lib:' $(STAGING_DIR)/usr/lib/libGL.la
	$(SED) 's:-L[^[:space:]]\+::' $(STAGING_DIR)/usr/lib/libGL.la
	$(INSTALL) -D -m 0644 package/nvidia-driver/gl.pc $(STAGING_DIR)/usr/lib/pkgconfig/gl.pc
endef

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

endif # X drivers

ifeq ($(BR2_PACKAGE_NVIDIA_DRIVER_CUDA),y)
NVIDIA_DRIVER_LIBS += libcuda libnvidia-compiler libnvcuvid libnvidia-encode
ifeq ($(BR2_PACKAGE_NVIDIA_DRIVER_CUDA_PROGS),y)
NVIDIA_DRIVER_PROGS = nvidia-cuda-mps-control nvidia-cuda-mps-server
endif
endif

ifeq ($(BR2_PACKAGE_NVIDIA_DRIVER_OPENCL),y)
NVIDIA_DRIVER_LIBS_NO_VERSION += libOpenCL.so.1.0.0
NVIDIA_DRIVER_LIBS += libnvidia-opencl
endif

# The downloaded archive is in fact an auto-extract script. So, it can run
# virtually everywhere, and it is fine enough to provide useful options.
# Except it can't extract into an existing (even empty) directory.
define NVIDIA_DRIVER_EXTRACT_CMDS
	$(SHELL) $(DL_DIR)/$(NVIDIA_DRIVER_SOURCE) --extract-only --target \
		$(@D)/tmp-extract
	mv $(@D)/tmp-extract/* $(@D)/tmp-extract/.manifest $(@D)
	rm -rf $(@D)/tmp-extract
endef

# Build and install the kernel modules if needed
ifeq ($(BR2_PACKAGE_NVIDIA_DRIVER_MODULE),y)

NVIDIA_DRIVER_DEPENDENCIES += linux

# NVidia uses the legacy naming scheme for the x86 architecture, when i386
# and x86_64 were still considered two separate architectures in the Linux
# kernel.
NVIDIA_DRIVER_ARCH = $(if $(BR2_i386),i386,$(BR2_ARCH))

NVIDIA_DRIVER_MOD_DIRS = kernel
NVIDIA_DRIVER_MOD_FILES = kernel/nvidia.ko
# nvidia-uvm.ko only available for x86_64
ifeq ($(BR2_x86_64)$(BR2_PACKAGE_NVIDIA_DRIVER_CUDA),yy)
NVIDIA_DRIVER_MOD_DIRS += kernel/uvm
NVIDIA_DRIVER_MOD_FILES += kernel/uvm/nvidia-uvm.ko
endif

# We can not use '$(MAKE) -C $(@D)/$${dir}' because NVidia's uses its own
# Makefile to build a kernel module, which includes a lot of assumptions
# on where to find its own sub-Makefile fragments, and fails if make is
# not run from the directory where the module's source files are. Hence
# our little trick to cd in there first.
# That's also the reason why we do not use LINUX_MAKE_FLAGS or the other
# linux-specific variables, since NVidia's Makefile does not understand
# them.
define NVIDIA_DRIVER_BUILD_CMDS
	for dir in $(NVIDIA_DRIVER_MOD_DIRS); do \
		(cd $(@D)/$${dir} && \
		  $(MAKE) SYSSRC="$(LINUX_DIR)" SYSOUT="$(LINUX_DIR)" \
				CC="$(TARGET_CC)" LD="$(TARGET_LD)" HOSTCC="$(HOSTCC)" \
				ARCH=$(NVIDIA_DRIVER_ARCH) module) || exit 1; \
	done
endef

# We do not use module-install because NVidia's Makefile requires root.
# Also, we do not install it in the expected location (in nvidia/ rather
# than in kernel/drivers/video/)
define NVIDIA_DRIVER_INSTALL_KERNEL_MODULE
	for mod in $(NVIDIA_DRIVER_MOD_FILES); do \
		$(INSTALL) -D -m 0644 $(@D)/$${mod} \
			$(TARGET_DIR)/lib/modules/$(LINUX_VERSION_PROBED)/nvidia/$${mod##*/} \
		|| exit 1; \
	done
	$(HOST_DIR)/sbin/depmod -a -b $(TARGET_DIR) $(LINUX_VERSION_PROBED)
endef

endif # BR2_PACKAGE_NVIDIA_DRIVER_MODULE == y

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
	$(NVIDIA_DRIVER_INSTALL_GL_DEV)
endef

# For target, install libraries and X.org modules
define NVIDIA_DRIVER_INSTALL_TARGET_CMDS
	$(call NVIDIA_DRIVER_INSTALL_LIBS,$(TARGET_DIR))
	for m in $(NVIDIA_DRIVER_X_MODS); do \
		$(INSTALL) -D -m 0644 $(@D)/$${m##*/} \
			$(TARGET_DIR)/usr/lib/xorg/modules/$${m}; \
	done
	for p in $(NVIDIA_DRIVER_PROGS); do \
		$(INSTALL) -D -m 0755 $(@D)/$${p} \
			$(TARGET_DIR)/usr/bin/$${p}; \
	done
	$(NVIDIA_DRIVER_INSTALL_KERNEL_MODULE)
endef

$(eval $(generic-package))
