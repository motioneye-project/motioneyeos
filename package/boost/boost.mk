################################################################################
#
# boost
#
################################################################################

BOOST_VERSION = 1.57.0
BOOST_SOURCE = boost_$(subst .,_,$(BOOST_VERSION)).tar.bz2
BOOST_SITE = http://downloads.sourceforge.net/project/boost/boost/$(BOOST_VERSION)
BOOST_INSTALL_STAGING = YES
BOOST_LICENSE = Boost Software License 1.0
BOOST_LICENSE_FILES = LICENSE_1_0.txt

TARGET_CC_VERSION = $(shell $(TARGET_CC) -dumpversion)
HOST_CC_VERSION = $(shell $(HOSTCC) -dumpversion)

HOST_BOOST_DEPENDENCIES =

# keep host variant as minimal as possible
HOST_BOOST_FLAGS = --without-icu \
	--without-libraries=$(subst $(space),$(comma),atomic chrono context \
	coroutine date_time exception filesystem graph graph_parallel \
	iostreams locale log math mpi program_options python random regex \
	serialization signals system test thread timer wave)

# atomic library compile only with upstream version, wait for next release
# coroutine breaks on some weak toolchains and it's new for 1.54+
# log breaks with some toolchain combinations and it's new for 1.54+
BOOST_WITHOUT_FLAGS = atomic coroutine log

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
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_PYTHON),,python)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_RANDOM),,random)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_REGEX),,regex)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_SERIALIZATION),,serialization)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_SIGNALS),,signals)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_SYSTEM),,system)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_TEST),,test)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_THREAD),,thread)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_TIMER),,timer)
BOOST_WITHOUT_FLAGS += $(if $(BR2_PACKAGE_BOOST_WAVE),,wave)

BOOST_TARGET_CXXFLAGS = $(TARGET_CXXFLAGS)

ifeq ($(BR2_PACKAGE_ICU),y)
BOOST_FLAGS += --with-icu=$(STAGING_DIR)/usr
BOOST_DEPENDENCIES += icu
else
BOOST_FLAGS += --without-icu
endif

ifeq ($(BR2_PACKAGE_BOOST_IOSTREAMS),y)
BOOST_DEPENDENCIES += bzip2 zlib
endif

ifeq ($(BR2_PACKAGE_BOOST_PYTHON),y)
BOOST_FLAGS += --with-python-root=$(HOST_DIR)
ifeq ($(BR2_PACKAGE_PYTHON3),y)
BOOST_FLAGS += --with-python=$(HOST_DIR)/usr/bin/python$(PYTHON3_VERSION_MAJOR)
BOOST_TARGET_CXXFLAGS += -I$(STAGING_DIR)/usr/include/python$(PYTHON3_VERSION_MAJOR)m
BOOST_DEPENDENCIES += python3
else
BOOST_FLAGS += --with-python=$(HOST_DIR)/usr/bin/python$(PYTHON_VERSION_MAJOR)
BOOST_TARGET_CXXFLAGS += -I$(STAGING_DIR)/usr/include/python$(PYTHON_VERSION_MAJOR)
BOOST_DEPENDENCIES += python
endif
endif

HOST_BOOST_OPTS += toolset=gcc threading=multi variant=release link=shared \
	runtime-link=shared

ifeq ($(BR2_MIPS_OABI32),y)
BOOST_ABI = o32
else ifeq ($(BR2_arm),y)
BOOST_ABI = aapcs
else
BOOST_ABI = sysv
endif

BOOST_OPTS += toolset=gcc \
	     threading=multi \
	     abi=$(BOOST_ABI) \
	     variant=$(if $(BR2_ENABLE_DEBUG),debug,release) \
	     link=$(if $(BR2_STATIC_LIBS),static,shared) \
	     runtime-link=$(if $(BR2_STATIC_LIBS),static,shared)

ifeq ($(BR2_PACKAGE_BOOST_LOCALE),y)
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),y)
# posix backend needs monetary.h which isn't available on uClibc
BOOST_OPTS += boost.locale.posix=off
endif

BOOST_DEPENDENCIES += $(if $(BR2_ENABLE_LOCALE),,libiconv)
endif

BOOST_WITHOUT_FLAGS_COMMASEPERATED += $(subst $(space),$(comma),$(strip $(BOOST_WITHOUT_FLAGS)))
BOOST_FLAGS += $(if $(BOOST_WITHOUT_FLAGS_COMMASEPERATED), --without-libraries=$(BOOST_WITHOUT_FLAGS_COMMASEPERATED))
BOOST_LAYOUT = $(call qstrip, $(BR2_PACKAGE_BOOST_LAYOUT))

define BOOST_CONFIGURE_CMDS
	(cd $(@D) && ./bootstrap.sh $(BOOST_FLAGS))
	echo "using gcc : $(TARGET_CC_VERSION) : $(TARGET_CXX) : <cxxflags>\"$(BOOST_TARGET_CXXFLAGS)\" <linkflags>\"$(TARGET_LDFLAGS)\" ;" > $(@D)/user-config.jam
	echo "" >> $(@D)/user-config.jam
endef

define HOST_BOOST_CONFIGURE_CMDS
	(cd $(@D) && ./bootstrap.sh $(HOST_BOOST_FLAGS))
	echo "using gcc : $(HOST_CC_VERSION) : $(HOSTCXX) : <cxxflags>\"$(HOST_CXXFLAGS)\" <linkflags>\"$(HOST_LDFLAGS)\" ;" > $(@D)/user-config.jam
	echo "" >> $(@D)/user-config.jam
endef

define BOOST_INSTALL_TARGET_CMDS
	(cd $(@D) && ./b2 -j$(PARALLEL_JOBS) -q -d+1 \
	--user-config=$(@D)/user-config.jam \
	$(BOOST_OPTS) \
	--prefix=$(TARGET_DIR)/usr \
	--ignore-site-config \
	--layout=$(BOOST_LAYOUT) install )
endef

define HOST_BOOST_BUILD_CMDS
	(cd $(@D) && ./b2 -j$(PARALLEL_JOBS) -q -d+1 \
	--user-config=$(@D)/user-config.jam \
	$(HOST_BOOST_OPTS) \
	--ignore-site-config \
	--prefix=$(HOST_DIR)/usr )
endef

define HOST_BOOST_INSTALL_CMDS
	(cd $(@D) && ./b2 -j$(PARALLEL_JOBS) -q -d+1 \
	--user-config=$(@D)/user-config.jam \
	$(HOST_BOOST_OPTS) \
	--prefix=$(HOST_DIR)/usr \
	--ignore-site-config \
	--layout=$(BOOST_LAYOUT) install )
endef

define BOOST_INSTALL_STAGING_CMDS
	(cd $(@D) && ./bjam -j$(PARALLEL_JOBS) -d+1 \
	--user-config=$(@D)/user-config.jam \
	$(BOOST_OPTS) \
	--prefix=$(STAGING_DIR)/usr \
	--ignore-site-config \
	--layout=$(BOOST_LAYOUT) install)
endef

$(eval $(generic-package))
$(eval $(host-generic-package))
