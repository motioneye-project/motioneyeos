ifeq ($(BR2_PACKAGE_MATCHBOX),y)
include package/matchbox/*/*.mk
TARGETS+=matchbox-lib matchbox-wm
endif
