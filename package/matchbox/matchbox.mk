ifeq ($(BR2_PACKAGE_MATCHBOX),y)
include $(sort $(wildcard package/matchbox/*/*.mk))
PACKAGES += matchbox-lib matchbox-wm
endif
