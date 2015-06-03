ifeq ($(BR2_PACKAGE_MATCHBOX),y)
include $(sort $(wildcard package/matchbox/*/*.mk))
endif
