################################################################################
#
# spice
#
################################################################################

SPICE_VERSION = 0.12.6
SPICE_SOURCE = spice-$(SPICE_VERSION).tar.bz2
SPICE_SITE = http://www.spice-space.org/download/releases
SPICE_LICENSE = LGPL-2.1+
SPICE_LICENSE_FILES = COPYING
SPICE_INSTALL_STAGING = YES
SPICE_DEPENDENCIES = \
	jpeg \
	libglib2 \
	openssl \
	pixman \
	spice-protocol

# We disable everything for now, because the dependency tree can become
# quite deep if we try to enable some features, and I have not tested that.
SPICE_CONF_OPTS = \
	--disable-opengl \
	--disable-smartcard \
	--disable-automated-tests \
	--without-sasl \
	--disable-manual

SPICE_DEPENDENCIES += host-pkgconf

ifeq ($(BR2_PACKAGE_CELT051),y)
SPICE_CONF_OPTS += --enable-celt051
SPICE_DEPENDENCIES += celt051
else
SPICE_CONF_OPTS += --disable-celt051
endif

ifeq ($(BR2_PACKAGE_LZ4),y)
SPICE_CONF_OPTS += --enable-lz4
SPICE_DEPENDENCIES += lz4
else
SPICE_CONF_OPTS += --disable-lz4
endif

# no enable/disable, detected using pkg-config
ifeq ($(BR2_PACKAGE_OPUS),y)
SPICE_DEPENDENCIES += opus
endif

# build system uses pkg-config --variable=codegendir spice-protocol which
# returns the runtime path rather than build time, so it needs some help
SPICE_MAKE_OPTS = CODE_GENERATOR_BASEDIR=$(STAGING_DIR)/usr/lib/spice-protocol
SPICE_INSTALL_STAGING_OPTS = $(SPICE_MAKE_OPTS) DESTDIR=$(STAGING_DIR) install
SPICE_INSTALL_TARGET_OPTS = $(SPICE_MAKE_OPTS) DESTDIR=$(TARGET_DIR) install

# spice uses a number of source files that are generated with python / pyparsing.
# The generated files are part of the tarball, so python / pyparsing isn't needed
# when building from the tarball, but the configure script gets confused and looks
# for the wrong file name to know if it needs to check for python / pyparsing,
# so convince it they aren't needed.
# It will also regenerate these files if the spice-protocol protocol definition
# is newer than the generated files (which it will be when spice-protocol
# installs it to staging), so ensure their timestamp is updated to skip this.
define SPICE_NO_PYTHON_PYPARSING
	mkdir -p $(@D)/client
	touch $(@D)/client/generated_marshallers.cpp
	touch $(@D)/spice-common/common/generated_*
endef

SPICE_PRE_CONFIGURE_HOOKS += SPICE_NO_PYTHON_PYPARSING

# We need to tweak spice.pc because it /forgets/ (for static linking) that
# it should link against libz and libjpeg. libz is pkg-config-aware, while
# libjpeg isn't, hence the two-line tweak
define SPICE_POST_INSTALL_STAGING_FIX_PC
	$(SED) 's/^\(Requires.private:.*\)$$/\1 zlib/; s/^\(Libs.private:.*\)$$/\1 -ljpeg/;' \
		"$(STAGING_DIR)/usr/lib/pkgconfig/spice-server.pc"
endef
SPICE_POST_INSTALL_STAGING_HOOKS += SPICE_POST_INSTALL_STAGING_FIX_PC

# It is currently not possible to detect if stack-protection is available
# or not, because it requires support from both the compiler *and* the
# C library, but the C library (eg. uClibc) can be compiled without that
# support, even if gcc accepts the -fstack-protector-all option.
# spice's ./configure only checks for gcc's -fstack-protector-all option,
# so it misses the case where the C library doe not provide the requires
# support.
# A correct fix would be to fix spice's ./configure to also check the C
# library, but it might be much more involved.
# So, we simply disable it for now. After all, as uClibc's help puts it:
#     Note that NOEXECSTACK on a kernel with address space randomization
#     is generally sufficient to prevent most buffer overflow exploits
#     without increasing code size.
SPICE_CONF_OPTS += gl_cv_warn__fstack_protector_all=no

$(eval $(autotools-package))
