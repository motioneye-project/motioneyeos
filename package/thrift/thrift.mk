################################################################################
#
# thrift
#
################################################################################

THRIFT_VERSION = 0.13.0
THRIFT_SITE = http://www.us.apache.org/dist/thrift/$(THRIFT_VERSION)
THRIFT_LICENSE = Apache-2.0
THRIFT_LICENSE_FILES = LICENSE

THRIFT_DEPENDENCIES = host-pkgconf host-thrift boost \
	libevent openssl zlib
THRIFT_INSTALL_STAGING = YES
HOST_THRIFT_DEPENDENCIES = host-bison host-boost \
	host-flex host-libevent host-openssl host-pkgconf host-zlib

THRIFT_COMMON_CONF_OPTS = -DBUILD_TUTORIALS=OFF \
	-DBUILD_TESTING=OFF \
	-DWITH_PYTHON=OFF \
	-DWITH_JAVA=OFF \
	-DWITH_QT4=OFF \
	-DWITH_QT5=OFF

THRIFT_CONF_OPTS = $(THRIFT_COMMON_CONF_OPTS) -DBUILD_COMPILER=OFF
HOST_THRIFT_CONF_OPTS = $(THRIFT_COMMON_CONF_OPTS) -DBUILD_COMPILER=ON

# relocation truncated to fit: R_68K_GOT16O
ifeq ($(BR2_m68k_cf),y)
THRIFT_CONF_ENV += CXXFLAGS="$(TARGET_CXXFLAGS) -mxgot"
endif

# thrift doesn't use the regular flags BUILD_{STATIC,SHARED}_LIBS
ifeq ($(BR2_STATIC_LIBS),y)
THRIFT_CONF_OPTS += -DWITH_STATIC_LIB=ON -DWITH_BOOST_STATIC=ON -DWITH_SHARED_LIB=OFF
else ifeq ($(BR2_SHARED_LIBS),y)
THRIFT_CONF_OPTS += -DWITH_STATIC_LIB=OFF -DWITH_BOOST_STATIC=OFF -DWITH_SHARED_LIB=ON
else
# BR2_SHARED_STATIC_LIBS
THRIFT_CONF_OPTS += -DWITH_STATIC_LIB=ON -DWITH_BOOST_STATIC=OFF -DWITH_SHARED_LIB=ON
endif

# Language selection for the compiler
HOST_THRIFT_CONF_OPTS += -DTHRIFT_COMPILER_CSHARP=OFF \
	-DTHRIFT_COMPILER_JAVA=OFF \
	-DTHRIFT_COMPILER_ERL=OFF \
	-DTHRIFT_COMPILER_PY=OFF \
	-DTHRIFT_COMPILER_PERL=OFF \
	-DTHRIFT_COMPILER_PHP=OFF \
	-DTHRIFT_COMPILER_RB=OFF \
	-DTHRIFT_COMPILER_HS=OFF \
	-DTHRIFT_COMPILER_GO=OFF \
	-DTHRIFT_COMPILER_D=OFF \
	-DTHRIFT_COMPILER_LUA=OFF \
	-DBUILD_C_GLIB=OFF

# C bindings
ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
THRIFT_DEPENDENCIES += libglib2
THRIFT_CONF_OPTS += -DBUILD_C_GLIB=ON
else
THRIFT_CONF_OPTS += -DBUILD_C_GLIB=OFF
endif

$(eval $(cmake-package))
$(eval $(host-cmake-package))

# to be used by other packages
THRIFT = $(HOST_DIR)/bin/thrift
