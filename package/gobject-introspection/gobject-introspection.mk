################################################################################
#
# gobject-introspection
#
################################################################################

GOBJECT_INTROSPECTION_VERSION_MAJOR = 1.64
GOBJECT_INTROSPECTION_VERSION = $(GOBJECT_INTROSPECTION_VERSION_MAJOR).1
GOBJECT_INTROSPECTION_SITE = http://ftp.gnome.org/pub/GNOME/sources/gobject-introspection/$(GOBJECT_INTROSPECTION_VERSION_MAJOR)
GOBJECT_INTROSPECTION_SOURCE = gobject-introspection-$(GOBJECT_INTROSPECTION_VERSION).tar.xz
GOBJECT_INTROSPECTION_INSTALL_STAGING = YES
GOBJECT_INTROSPECTION_AUTORECONF = YES
GOBJECT_INTROSPECTION_LICENSE = LGPL-2.0+, GPL-2.0+, BSD-2-Clause
GOBJECT_INTROSPECTION_LICENSE_FILES = COPYING.LGPL COPYING.GPL giscanner/scannerlexer.l

GOBJECT_INTROSPECTION_DEPENDENCIES = \
	host-autoconf-archive \
	host-gobject-introspection \
	host-prelink-cross \
	host-qemu \
	libffi \
	libglib2 \
	python3 \
	zlib

HOST_GOBJECT_INTROSPECTION_DEPENDENCIES = \
	host-bison \
	host-flex \
	host-libglib2 \
	host-python3

# g-ir-scanner will default to /usr/bin/ld for linking if this is not set.
GOBJECT_INTROSPECTION_NINJA_ENV += \
	CC="$(TARGET_CC)"

# When building, gobject-introspection uses tools/g-ir-scanner to build several
# .gir and .typelib files. g-ir-scanner does not use LDFLAGS, and by default,
# links to the system-installed libglib2 path. To remedy this issue, defining
# LD_LIBRARY_PATH forces g-ir-scanner to use our host installed libglib2 files.
HOST_GOBJECT_INTROSPECTION_NINJA_ENV += \
	LD_LIBRARY_PATH="$(if $(LD_LIBRARY_PATH),$(LD_LIBRARY_PATH):)$(HOST_DIR)/lib"

# Use the host gi-scanner to prevent the scanner from generating incorrect
# elf classes.
GOBJECT_INTROSPECTION_CONF_OPTS = \
	-Dgi_cross_use_host_gi=true \
	-Dgi_cross_binary_wrapper="$(STAGING_DIR)/usr/bin/g-ir-scanner-qemuwrapper" \
	-Dgi_cross_ldd_wrapper="$(STAGING_DIR)/usr/bin/g-ir-scanner-lddwrapper" \
	-Dbuild_introspection_data=true \
	-Ddoctool=disabled

ifeq ($(BR2_PACKAGE_CAIRO),y)
GOBJECT_INTROSPECTION_DEPENDENCIES += cairo
GOBJECT_INTROSPECTION_CONF_OPTS += -Dcairo=enabled
else
GOBJECT_INTROSPECTION_CONF_OPTS += -Dcairo=disabled
endif

# GI_SCANNER_DISABLE_CACHE=1 prevents g-ir-scanner from writing cache data to ${HOME}
GOBJECT_INTROSPECTION_CONF_ENV = \
	GI_SCANNER_DISABLE_CACHE=1

HOST_GOBJECT_INTROSPECTION_CONF_ENV = \
	GI_SCANNER_DISABLE_CACHE=1

# Make sure g-ir-tool-template uses the host python.
define GOBJECT_INTROSPECTION_FIX_TOOLTEMPLATE_PYTHON_PATH
	$(SED) '1s%#!.*%#!$(HOST_DIR)/bin/python%' $(@D)/tools/g-ir-tool-template.in
endef
HOST_GOBJECT_INTROSPECTION_PRE_CONFIGURE_HOOKS += GOBJECT_INTROSPECTION_FIX_TOOLTEMPLATE_PYTHON_PATH

# Perform the following:
# - Just as above, Ensure that g-ir-tool-template.in uses the host python.
# - Install all of the wrappers needed to build gobject-introspection.
# - Create a safe modules directory which does not exist so we don't load random things
#   which may then get deleted (or their dependencies) and potentially segfault
define GOBJECT_INTROSPECTION_INSTALL_PRE_WRAPPERS
	$(SED) '1s%#!.*%#!$(HOST_DIR)/bin/python%' $(@D)/tools/g-ir-tool-template.in

	$(INSTALL) -D -m 755 $(GOBJECT_INTROSPECTION_PKGDIR)/g-ir-scanner-lddwrapper.in \
		$(STAGING_DIR)/usr/bin/g-ir-scanner-lddwrapper

	$(INSTALL) -D -m 755 $(GOBJECT_INTROSPECTION_PKGDIR)/g-ir-scanner-qemuwrapper.in \
		$(STAGING_DIR)/usr/bin/g-ir-scanner-qemuwrapper
	$(SED) "s%@QEMU_USER@%$(QEMU_USER)%g" \
		$(STAGING_DIR)/usr/bin/g-ir-scanner-qemuwrapper
	$(SED) "s%@TOOLCHAIN_HEADERS_VERSION@%$(BR2_TOOLCHAIN_HEADERS_AT_LEAST)%g" \
		$(STAGING_DIR)/usr/bin/g-ir-scanner-qemuwrapper

	# Use a modules directory which does not exist so we don't load random things
	# which may then get deleted (or their dependencies) and potentially segfault
	mkdir -p $(STAGING_DIR)/usr/lib/gio/modules-dummy
endef
GOBJECT_INTROSPECTION_PRE_CONFIGURE_HOOKS += GOBJECT_INTROSPECTION_INSTALL_PRE_WRAPPERS

# Move the real compiler and scanner to .real, and replace them with the wrappers.
# Using .real has the following advantages:
# - There is no need to change the logic for other packages.
# - The wrappers call the .real files using qemu.
define GOBJECT_INTROSPECTION_INSTALL_WRAPPERS
	# Move the real binaries to their names.real, then replace them with
	# the wrappers.
	$(foreach w,g-ir-compiler g-ir-scanner,
		mv $(STAGING_DIR)/usr/bin/$(w) $(STAGING_DIR)/usr/bin/$(w).real
		$(INSTALL) -D -m 755 \
			$(GOBJECT_INTROSPECTION_PKGDIR)/$(w).in $(STAGING_DIR)/usr/bin/$(w)
	)
	$(SED) "s%@BASENAME_TARGET_CPP@%$(notdir $(TARGET_CPP))%g" \
		-e "s%@BASENAME_TARGET_CC@%$(notdir $(TARGET_CC))%g" \
		-e "s%@BASENAME_TARGET_CXX@%$(notdir $(TARGET_CXX))%g" \
		-e "s%@TARGET_CPPFLAGS@%$(TARGET_CPPFLAGS)%g" \
		-e "s%@TARGET_CFLAGS@%$(TARGET_CFLAGS)%g" \
		-e "s%@TARGET_CXXFLAGS@%$(TARGET_CXXFLAGS)%g" \
		-e "s%@TARGET_LDFLAGS@%$(TARGET_LDFLAGS)%g" \
		$(STAGING_DIR)/usr/bin/g-ir-scanner

	# Gobject-introspection installs Makefile.introspection in
	# $(STAGING_DIR)/usr/share which is needed for autotools-based programs to
	# build .gir and .typelib files. Unfortuantly, gobject-introspection-1.0.pc
	# uses $(prefix)/share as the directory, which
	# causes the host /usr/share being used instead of $(STAGING_DIR)/usr/share.
	# Change datarootdir to $(libdir)/../share which will prefix $(STAGING_DIR)
	# to the correct location.
	$(SED) "s%datarootdir=.*%datarootdir=\$${libdir}/../share%g" \
		$(STAGING_DIR)/usr/lib/pkgconfig/gobject-introspection-1.0.pc

	# By default, girdir and typelibdir use datadir and libdir as their prefix,
	# of which pkg-config appends the sysroot directory. This results in files
	# being installed in $(STAGING_DIR)/$(STAGING_DIR)/path/to/files.
	# Changing the prefix to exec_prefix prevents this error.
	$(SED) "s%girdir=.*%girdir=\$${exec_prefix}/share/gir-1.0%g" \
		$(STAGING_DIR)/usr/lib/pkgconfig/gobject-introspection-1.0.pc

	$(SED) "s%typelibdir=.*%typelibdir=\$${exec_prefix}/lib/girepository-1.0%g" \
		$(STAGING_DIR)/usr/lib/pkgconfig/gobject-introspection-1.0.pc
endef
GOBJECT_INTROSPECTION_POST_INSTALL_STAGING_HOOKS += GOBJECT_INTROSPECTION_INSTALL_WRAPPERS

# Only .typelib files are needed to run.
define GOBJECT_INTROSPECTION_REMOVE_DEVELOPMENT_FILES
	find $(TARGET_DIR)/usr/share \( -iname "*.gir" -o -iname \*.rnc \) -delete
endef
GOBJECT_INTROSPECTION_TARGET_FINALIZE_HOOKS += GOBJECT_INTROSPECTION_REMOVE_DEVELOPMENT_FILES

$(eval $(meson-package))
$(eval $(host-meson-package))
