################################################################################
#
# dt
#
################################################################################

DT_VERSION = 18.32
DT_SITE = http://pkgs.fedoraproject.org/repo/pkgs/dt/$(DT_SOURCE)/3054aeaaba047a1dbe90c2132a382ee2
DT_SOURCE = dt-source-v$(DT_VERSION).tar.gz
DT_STRIP_COMPONENTS = 2
DT_LICENSE = ISC-like
DT_LICENSE_FILES = LICENSE

DT_CFLAGS = \
	-std=c99 \
	-DMMAP \
	-D__linux__ \
	-D_GNU_SOURCE \
	-D_FILE_OFFSET_BITS=64 \
	-DTHREADS \
	-DSCSI

# uClibc doesn't provide POSIX AIO
ifeq ($(BR2_TOOLCHAIN_USES_UCLIBC),)
DT_CFLAGS += -DAIO
endif

define DT_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) -C $(@D) -f Makefile.linux \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS) $(DT_CFLAGS)" \
		OS=linux
endef

define DT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/dt $(TARGET_DIR)/usr/bin/dt
endef

$(eval $(generic-package))
