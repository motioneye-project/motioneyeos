################################################################################
#
# pcm-tools
#
################################################################################

PCM_TOOLS_VERSION = 201812
PCM_TOOLS_SITE = $(call github,opcm,pcm,$(PCM_TOOLS_VERSION))
PCM_TOOLS_LICENSE = BSD-3-Clause
PCM_TOOLS_LICENSE_FILES = LICENSE

PCM_TOOLS_EXE_FILES = \
	pcm-core pcm-iio pcm-lspci pcm-memory pcm-msr pcm-numa \
	pcm-pcicfg pcm-pcie pcm-power pcm-sensor pcm-tsx pcm

define PCM_TOOLS_BUILD_CMDS
	touch $(@D)/daemon-binaries
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D) \
		CXXFLAGS="$(TARGET_CXXFLAGS) -std=c++11" \
		UNAME=Linux HOST=_LINUX
endef

ifeq ($(BR2_PACKAGE_PCM_TOOLS_PMU_QUERY),y)
define PCM_TOOLS_INSTALL_PMU_QUERY
	$(INSTALL) -D -m 755 $(@D)/pmu-query.py $(TARGET_DIR)/usr/bin/pmu-query
endef
endif

define PCM_TOOLS_INSTALL_TARGET_CMDS
	$(foreach f,$(PCM_TOOLS_EXE_FILES),\
		$(INSTALL) -D -m 755 $(@D)/$(f).x $(TARGET_DIR)/usr/bin/$(f)
	)
	$(PCM_TOOLS_INSTALL_PMU_QUERY)
endef

$(eval $(generic-package))
