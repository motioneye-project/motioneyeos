################################################################################
#
# python3
#
################################################################################

PYTHON3_VERSION_MAJOR = 3.6
PYTHON3_VERSION = $(PYTHON3_VERSION_MAJOR).3
PYTHON3_SOURCE = Python-$(PYTHON3_VERSION).tar.xz
PYTHON3_SITE = https://python.org/ftp/python/$(PYTHON3_VERSION)
PYTHON3_LICENSE = Python-2.0, others
PYTHON3_LICENSE_FILES = LICENSE

# Python itself doesn't use libtool, but it includes the source code
# of libffi, which uses libtool. Unfortunately, it uses a beta version
# of libtool for which we don't have a matching patch. However, this
# is not a problem, because we don't use the libffi copy included in
# the Python sources, but instead use an external libffi library.
PYTHON3_LIBTOOL_PATCH = NO

# This host Python is installed in $(HOST_DIR), as it is needed when
# cross-compiling third-party Python modules.

HOST_PYTHON3_CONF_OPTS += \
	--without-ensurepip \
	--without-cxx-main \
	--disable-sqlite3 \
	--disable-tk \
	--with-expat=system \
	--disable-curses \
	--disable-codecs-cjk \
	--disable-nis \
	--enable-unicodedata \
	--disable-test-modules \
	--disable-idle3 \
	--disable-ossaudiodev \
	--disable-openssl

# Make sure that LD_LIBRARY_PATH overrides -rpath.
# This is needed because libpython may be installed at the same time that
# python is called.
# Make python believe we don't have 'hg', so that it doesn't try to
# communicate over the network during the build.
HOST_PYTHON3_CONF_ENV += \
	LDFLAGS="$(HOST_LDFLAGS) -Wl,--enable-new-dtags" \
	ac_cv_prog_HAS_HG=/bin/false

PYTHON3_DEPENDENCIES = host-python3 libffi

HOST_PYTHON3_DEPENDENCIES = host-expat host-zlib

PYTHON3_INSTALL_STAGING = YES

ifeq ($(BR2_PACKAGE_PYTHON3_READLINE),y)
PYTHON3_DEPENDENCIES += readline
else
PYTHON3_CONF_OPTS += --disable-readline
endif

ifeq ($(BR2_PACKAGE_PYTHON3_CURSES),y)
PYTHON3_DEPENDENCIES += ncurses
else
PYTHON3_CONF_OPTS += --disable-curses
endif

ifeq ($(BR2_PACKAGE_PYTHON3_DECIMAL),y)
PYTHON3_DEPENDENCIES += mpdecimal
PYTHON3_CONF_OPTS += --with-libmpdec=system
else
PYTHON3_CONF_OPTS += --with-libmpdec=none
endif

ifeq ($(BR2_PACKAGE_PYTHON3_PYEXPAT),y)
PYTHON3_DEPENDENCIES += expat
PYTHON3_CONF_OPTS += --with-expat=system
else
PYTHON3_CONF_OPTS += --with-expat=none
endif

ifeq ($(BR2_PACKAGE_PYTHON3_PYC_ONLY),y)
PYTHON3_CONF_OPTS += --enable-old-stdlib-cache
endif

ifeq ($(BR2_PACKAGE_PYTHON3_SQLITE),y)
PYTHON3_DEPENDENCIES += sqlite
else
PYTHON3_CONF_OPTS += --disable-sqlite3
endif

ifeq ($(BR2_PACKAGE_PYTHON3_SSL),y)
PYTHON3_DEPENDENCIES += openssl
else
PYTHON3_CONF_OPTS += --disable-openssl
endif

ifneq ($(BR2_PACKAGE_PYTHON3_CODECSCJK),y)
PYTHON3_CONF_OPTS += --disable-codecs-cjk
endif

ifneq ($(BR2_PACKAGE_PYTHON3_UNICODEDATA),y)
PYTHON3_CONF_OPTS += --disable-unicodedata
endif

ifeq ($(BR2_PACKAGE_PYTHON3_BZIP2),y)
PYTHON3_DEPENDENCIES += bzip2
else
PYTHON3_CONF_OPTS += --disable-bzip2
endif

ifeq ($(BR2_PACKAGE_PYTHON3_XZ),y)
PYTHON3_DEPENDENCIES += xz
else
PYTHON3_CONF_OPTS += --disable-xz
endif

ifeq ($(BR2_PACKAGE_PYTHON3_ZLIB),y)
PYTHON3_DEPENDENCIES += zlib
else
PYTHON3_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_PYTHON3_OSSAUDIODEV),y)
PYTHON3_CONF_OPTS += --enable-ossaudiodev
else
PYTHON3_CONF_OPTS += --disable-ossaudiodev
endif

# Make python believe we don't have 'hg', so that it doesn't try to
# communicate over the network during the build.
PYTHON3_CONF_ENV += \
	ac_cv_have_long_long_format=yes \
	ac_cv_file__dev_ptmx=yes \
	ac_cv_file__dev_ptc=yes \
	ac_cv_working_tzset=yes \
	ac_cv_prog_HAS_HG=/bin/false

# GCC is always compliant with IEEE754
ifeq ($(BR2_ENDIAN),"LITTLE")
PYTHON3_CONF_ENV += ac_cv_little_endian_double=yes
else
PYTHON3_CONF_ENV += ac_cv_big_endian_double=yes
endif

# uClibc is known to have a broken wcsftime() implementation, so tell
# Python 3 to fall back to strftime() instead.
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
PYTHON3_CONF_ENV += ac_cv_func_wcsftime=no
endif

PYTHON3_CONF_OPTS += \
	--without-ensurepip \
	--without-cxx-main \
	--with-system-ffi \
	--disable-pydoc \
	--disable-test-modules \
	--disable-lib2to3 \
	--disable-tk \
	--disable-nis \
	--disable-idle3 \
	--disable-pyc-build

#
# Some of CPython's source code is generated using Python interpreter
# and some helper tools such as "Programs/_freeze_importlib" or
# "Parser/pgen" (look for regen-* targets in Makefile.pre.in for more
# info). Normally CPython codebase ships with those files
# pre-generated, so just regular "make" with no additional steps
# should be sufficient for a succesfull build, however due to
# Buildroot's "Add importlib fix for PEP 3147 issue" custom patch we
# end up modifying "Lib/importlib/_bootstrap_external.py" which means
# we have to do "regen-importlib" step before building CPython
# (Importlib is a builtin module that needs to be "frozen"/converted
# to a C array of bytecode using "Programs/_freeze_importlib")
#
# To achive that we add pre-build steps to host-python3 as well as
# python3 that execute "regen-importlib" target.
#
# Unfortunately, for the target Python, "Programs/_freeze_importlib"
# is built for the target, while we need to run them at build time. So
# when installing host-python3, we copy them to $(HOST_DIR)/bin...
#
define HOST_PYTHON3_MAKE_REGEN_IMPORTLIB
	$(HOST_MAKE_ENV) $(PYTHON3_CONF_ENV) $(MAKE) $(HOST_CONFIGURE_OPTS) -C $(@D) regen-importlib
	cp $(@D)/Programs/_freeze_importlib $(HOST_DIR)/bin/python-freeze-importlib
endef

HOST_PYTHON3_PRE_BUILD_HOOKS += HOST_PYTHON3_MAKE_REGEN_IMPORTLIB
#
# ... And then, when building the target python we first buid
# 'Programs/_freeze_importlib' to force GNU Make to update all of the
# prerequisites of 'Programs/_freeze_importlib', then copy our stashed
# "host-usable" version over the one that was just build and then
# build "regen-importlib" target
#
define PYTHON3_MAKE_REGEN_IMPORTLIB
	$(TARGET_MAKE_ENV) $(PYTHON3_CONF_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) Programs/_freeze_importlib
	cp $(HOST_DIR)/bin/python-freeze-importlib $(@D)/Programs/_freeze_importlib
	$(TARGET_MAKE_ENV) $(PYTHON3_CONF_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) regen-importlib
endef

PYTHON3_PRE_BUILD_HOOKS += PYTHON3_MAKE_REGEN_IMPORTLIB

#
# Remove useless files. In the config/ directory, only the Makefile
# and the pyconfig.h files are needed at runtime.
#
define PYTHON3_REMOVE_USELESS_FILES
	rm -f $(TARGET_DIR)/usr/bin/python$(PYTHON3_VERSION_MAJOR)-config
	rm -f $(TARGET_DIR)/usr/bin/python$(PYTHON3_VERSION_MAJOR)m-config
	rm -f $(TARGET_DIR)/usr/bin/python3-config
	rm -f $(TARGET_DIR)/usr/bin/smtpd.py.3
	for i in `find $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/config-$(PYTHON3_VERSION_MAJOR)m/ \
		-type f -not -name pyconfig.h -a -not -name Makefile` ; do \
		rm -f $$i ; \
	done
	rm -rf $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/__pycache__/
	rm -rf $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/lib-dynload/sysconfigdata/__pycache__
	rm -rf $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/collections/__pycache__
	rm -rf $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/importlib/__pycache__
endef

PYTHON3_POST_INSTALL_TARGET_HOOKS += PYTHON3_REMOVE_USELESS_FILES

#
# Make sure libpython gets stripped out on target
#
define PYTHON3_ENSURE_LIBPYTHON_STRIPPED
	chmod u+w $(TARGET_DIR)/usr/lib/libpython$(PYTHON3_VERSION_MAJOR)*.so
endef

PYTHON3_POST_INSTALL_TARGET_HOOKS += PYTHON3_ENSURE_LIBPYTHON_STRIPPED

PYTHON3_AUTORECONF = YES

define PYTHON3_INSTALL_SYMLINK
	ln -fs python3 $(TARGET_DIR)/usr/bin/python
endef

ifneq ($(BR2_PACKAGE_PYTHON),y)
PYTHON3_POST_INSTALL_TARGET_HOOKS += PYTHON3_INSTALL_SYMLINK
endif

# Some packages may have build scripts requiring python3, whatever is the
# python version chosen for the target.
# Only install the python symlink in the host tree if python3 is enabled
# for the target.
ifeq ($(BR2_PACKAGE_PYTHON3),y)
define HOST_PYTHON3_INSTALL_SYMLINK
	ln -fs python3 $(HOST_DIR)/bin/python
	ln -fs python3-config $(HOST_DIR)/bin/python-config
endef

HOST_PYTHON3_POST_INSTALL_HOOKS += HOST_PYTHON3_INSTALL_SYMLINK
endif

# Provided to other packages
PYTHON3_PATH = $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR)/

$(eval $(autotools-package))
$(eval $(host-autotools-package))

ifeq ($(BR2_REPRODUCIBLE),y)
define PYTHON3_FIX_TIME
	find $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR) -name '*.py' -print0 | \
		xargs -0 --no-run-if-empty touch -d @$(SOURCE_DATE_EPOCH)
endef
endif

define PYTHON3_CREATE_PYC_FILES
	$(PYTHON3_FIX_TIME)
	PYTHONPATH="$(PYTHON3_PATH)" \
	cd $(TARGET_DIR) && $(HOST_DIR)/bin/python$(PYTHON3_VERSION_MAJOR) \
		$(TOPDIR)/support/scripts/pycompile.py \
		$(if $(BR2_REPRODUCIBLE),--force) \
		usr/lib/python$(PYTHON3_VERSION_MAJOR)
endef

ifeq ($(BR2_PACKAGE_PYTHON3_PYC_ONLY)$(BR2_PACKAGE_PYTHON3_PY_PYC),y)
PYTHON3_TARGET_FINALIZE_HOOKS += PYTHON3_CREATE_PYC_FILES
endif

ifeq ($(BR2_PACKAGE_PYTHON3_PYC_ONLY),y)
define PYTHON3_REMOVE_PY_FILES
	find $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR) -name '*.py' -print0 | \
		xargs -0 --no-run-if-empty rm -f
endef
PYTHON3_TARGET_FINALIZE_HOOKS += PYTHON3_REMOVE_PY_FILES
endif

# Normally, *.pyc files should not have been compiled, but just in
# case, we make sure we remove all of them.
ifeq ($(BR2_PACKAGE_PYTHON3_PY_ONLY),y)
define PYTHON3_REMOVE_PYC_FILES
	find $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR) -name '*.pyc' -print0 | \
		xargs -0 --no-run-if-empty rm -f
endef
PYTHON3_TARGET_FINALIZE_HOOKS += PYTHON3_REMOVE_PYC_FILES
endif

# In all cases, we don't want to keep the optimized .opt-1.pyc and
# .opt-2.pyc files, since they can't work without their non-optimized
# variant.
define PYTHON3_REMOVE_OPTIMIZED_PYC_FILES
	find $(TARGET_DIR)/usr/lib/python$(PYTHON3_VERSION_MAJOR) -name '*.opt-1.pyc' -print0 -o -name '*.opt-2.pyc' -print0 | \
		xargs -0 --no-run-if-empty rm -f
endef
PYTHON3_TARGET_FINALIZE_HOOKS += PYTHON3_REMOVE_OPTIMIZED_PYC_FILES
