################################################################################
#
# rtc-tools
#
################################################################################

RTC_TOOLS_VERSION = 33ef4aa1c92b0c92a351284d93d1ac5570de9cc7
RTC_TOOLS_SITE = git://git.kernel.org/pub/scm/linux/kernel/git/abelloni/rtc-tools.git
RTC_TOOLS_LICENSE = GPL-2.0
RTC_TOOLS_LICENSE_FILES = COPYING

RTC_TOOLS_BINARIES = rtc rtc-range

ifeq ($(BR2_TOOLCHAIN_HAS_THREADS),y)
RTC_TOOLS_BINARIES += rtc-sync
endif

define RTC_TOOLS_BUILD_CMDS
	$(foreach bin,$(RTC_TOOLS_BINARIES),\
		$(TARGET_CC) $(TARGET_CFLAGS) -o $(@D)/$(bin) $(@D)/$(bin).c
	)
endef

define RTC_TOOLS_INSTALL_TARGET_CMDS
	$(foreach bin,$(RTC_TOOLS_BINARIES),\
		$(INSTALL) -D -m 0755 $(@D)/$(bin) $(TARGET_DIR)/usr/bin/$(bin)
	)
endef

$(eval $(generic-package))
