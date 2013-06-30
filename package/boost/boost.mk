################################################################################
#
# boost
#
################################################################################

BOOST_VERSION = 1.53.0
BOOST_FILE_VERSION = $(subst .,_,$(BOOST_VERSION))
BOOST_SOURCE = boost_$(BOOST_FILE_VERSION).tar.bz2
BOOST_SITE = http://downloads.sourceforge.net/project/boost/boost/$(BOOST_VERSION)
BOOST_INSTALL_STAGING = YES

TARGET_CC_VERSION = $(shell $(TARGET_CC) -dumpversion)

BOOST_DEPENDENCIES =

BOOST_FLAGS =

# atomic library compile only with upstream version, wait for next release
BOOST_WITHOUT_FLAGS = python atomic

BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_CHRONO),,chrono)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_CONTEXT),,context)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_DATE_TIME),,date_time)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_EXCEPTION),,exception)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_FILESYSTEM),,filesystem)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_GRAPH),,graph)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_GRAPH_PARALLEL),,graph_parallel)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_IOSTREAMS),,iostreams)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_LOCALE),,locale)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_MATH),,math)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_MPI),,mpi)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_PROGRAM_OPTIONS),,program_options)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_RANDOM),,random)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_REGEX),,regex)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_SERIALIZATION),,serialization)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_SIGNALS),,signals)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_SYSTEM),,system)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_TEST),,test)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_THREAD),,thread)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_TIMER),,timer)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_WAVE),,wave)

ifeq ($(BR2_PACKAGE_ICU),y)
BOOST_FLAGS += --with-icu=$(STAGING_DIR)/usr
BOOST_DEPENDENCIES += icu
else
BOOST_FLAGS += --without-icu
endif

ifeq ($(BR2_PACKAGE_BOOST_IOSTREAMS),y)
BOOST_DEPENDENCIES += bzip2 zlib
endif

BOOST_OPT += toolset=gcc \
	     threading=multi \
	     variant=$(if $(BR2_ENABLE_DEBUG),debug,release) \
	     link=$(if $(BR2_PREFER_STATIC_LIB),static,shared) \
	     runtime-link=$(if $(BR2_PREFER_STATIC_LIB),static,shared)

ifeq ($(BR2_PACKAGE_BOOST_LOCALE),y)
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
# posix backend needs monetary.h which isn't available on uClibc
BOOST_OPT += boost.locale.posix=off
endif

BOOST_DEPENDENCIES += $(if $(BR2_ENABLE_LOCALE),,libiconv)
endif

BOOST_WITHOUT_FLAGS_COMMASEPERATED += $(subst $(space),$(comma),$(strip $(BOOST_WITHOUT_FLAGS)))
BOOST_FLAGS += $(if $(BOOST_WITHOUT_FLAGS_COMMASEPERATED), --without-libraries=$(BOOST_WITHOUT_FLAGS_COMMASEPERATED))

define BOOST_CONFIGURE_CMDS
	(cd $(@D) && ./bootstrap.sh $(BOOST_FLAGS))
	echo "using gcc : $(TARGET_CC_VERSION) : $(TARGET_CXX) : <cxxflags>\"$(TARGET_CXXFLAGS)\" <linkflags>\"$(TARGET_LDFLAGS)\" ;" > $(@D)/user-config.jam
	echo "" >> $(@D)/user-config.jam
endef

define BOOST_INSTALL_TARGET_CMDS
	(cd $(@D) && ./b2 -j$(PARALLEL_JOBS) -q -d+1 \
	--user-config=$(@D)/user-config.jam \
	$(BOOST_OPT) \
	--prefix=$(TARGET_DIR)/usr \
	--layout=system install )
endef

define BOOST_INSTALL_STAGING_CMDS
	(cd $(@D) && ./bjam -j$(PARALLEL_JOBS) -d+1 \
	--user-config=$(@D)/user-config.jam \
	$(BOOST_OPT) \
	--prefix=$(STAGING_DIR)/usr \
	--layout=system install)
endef

$(eval $(generic-package))
