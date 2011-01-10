#############################################################
#
# ltrace
#
#############################################################
LTRACE_VERSION      = 0.5.3
LTRACE_SOURCE       = ltrace_$(LTRACE_VERSION).orig.tar.gz
LTRACE_PATCH        = ltrace_$(LTRACE_VERSION)-2.1.diff.gz
LTRACE_SITE         = $(BR2_DEBIAN_MIRROR)/debian/pool/main/l/ltrace
LTRACE_MAKE         = $(MAKE1)
LTRACE_DEPENDENCIES = libelf

# ltrace uses arch=ppc for powerpc
LTRACE_ARCH:=$(KERNEL_ARCH:powerpc=ppc)
ifeq ("$(strip $(ARCH))","armeb")
LTRACE_ARCH:=arm
endif

define LTRACE_CONFIGURE_CMDS
	(cd $(@D) ; ./configure 		\
		--prefix=/usr			\
		CC='$(TARGET_CC)' 		\
		CFLAGS='$(TARGET_CFLAGS)')
endef

define LTRACE_BUILD_CMDS
	$(MAKE) -C $(@D) ARCH=$(LTRACE_ARCH)
endef

ifeq ($(BR2_HAVE_DOCUMENTATION),y)
define LTRACE_INSTALL_DOCUMENTATION
	$(INSTALL) -D $(@D)/ltrace.1 \
		$(TARGET_DIR)/usr/share/man/man1/ltrace.1
endef
endif

define LTRACE_INSTALL_TARGET_CMDS
	$(INSTALL) -D $(@D)/ltrace $(TARGET_DIR)/usr/bin
	$(LTRACE_INSTALL_DOCUMENTATION)
endef

$(eval $(call GENTARGETS,package,ltrace))
