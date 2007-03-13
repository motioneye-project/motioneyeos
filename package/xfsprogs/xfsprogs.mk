#############################################################
#
# xfsprogs
#
#############################################################
XFSPROGS_VER:=2.7.11
XFSPROGS_SOURCE=xfsprogs-$(XFSPROGS_VER).src.tar.gz
#XFSPROGS_SITE=ftp://oss.sgi.com/projects/xfs/cmd_tars
XFSPROGS_SITE=ftp://oss.sgi.com/projects/xfs/previous/cmd_tars/
XFSPROGS_DIR=$(BUILD_DIR)/xfsprogs-$(XFSPROGS_VER)
XFSPROGS_CAT:=$(ZCAT)
XFSPROGS_BINARY:=mkfs/mkfs.xfs
XFSPROGS_TARGET_BINARY:=sbin/mkfs.xfs

XFSPROGS_STRIP:= fsck/fsck.xfs mkfile/xfs_mkfile rtcp/xfs_rtcp
XFSPROGS_STRIP_LIBDEP:= \
	copy/xfs_copy db/xfs_db growfs/xfs_growfs io/xfs_io \
	logprint/xfs_logprint mkfs/fstyp mkfs/mkfs.xfs \
	repair/xfs_repair quota/xfs_quota

$(DL_DIR)/$(XFSPROGS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(XFSPROGS_SITE)/$(XFSPROGS_SOURCE)

xfsprogs-source: $(DL_DIR)/$(XFSPROGS_SOURCE)

$(XFSPROGS_DIR)/.unpacked: $(DL_DIR)/$(XFSPROGS_SOURCE)
	$(XFSPROGS_CAT) $(DL_DIR)/$(XFSPROGS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(XFSPROGS_DIR) package/xfsprogs/ xfsprogs\*.patch
	touch $(XFSPROGS_DIR)/.unpacked

#XFSPROGS_CONFIG_SHARED:=--disable-shared
XFSPROGS_CONFIG_SHARED:=--enable-shared

$(XFSPROGS_DIR)/.configured: $(XFSPROGS_DIR)/.unpacked
	(cd $(XFSPROGS_DIR); rm -rf config.cache; \
		$(TARGET_CONFIGURE_OPTS) \
		CFLAGS="$(TARGET_CFLAGS)" \
		CPPFLAGS=-I$(E2FSPROGS_DIR)/lib \
		LDFLAGS="$(TARGET_LDFLAGS) -L$(E2FSPROGS_DIR)/lib" \
		LIBTOOL=$(LIBTOOL_DIR)/libtool \
		INSTALL_USER=$(shell whoami) \
		INSTALL_GROUP=$(shell groups | cut -d" " -f1) \
		./configure \
		--target=$(GNU_TARGET_NAME) \
		--host=$(GNU_TARGET_NAME) \
		--build=$(GNU_HOST_NAME) \
		--prefix=/usr \
		--exec-prefix=/ \
		--libdir=/usr/lib \
		$(XFSPROGS_CONFIG_SHARED) \
	);
	touch $(XFSPROGS_DIR)/.configured

$(XFSPROGS_DIR)/$(XFSPROGS_BINARY): $(XFSPROGS_DIR)/.configured
	$(MAKE1) PATH=$(TARGET_PATH) CPPFLAGS=-I$(E2FSPROGS_DIR)/lib \
		LDFLAGS=-L$(E2FSPROGS_DIR)/lib -C $(XFSPROGS_DIR)
ifeq ($(XFSPROGS_CONFIG_SHARED),--enable-shared)
	( \
		cd $(XFSPROGS_DIR) ; \
		$(STRIP) $(XFSPROGS_STRIP) ; \
		$(STRIP) $(join $(dir $(XFSPROGS_STRIP_LIBDEP)), \
				$(addprefix .libs/,$(notdir $(XFSPROGS_STRIP_LIBDEP)))) \
	)
	$(STRIP) $(XFSPROGS_DIR)/lib*/.libs/lib*.so.*.*
else
	( \
		cd $(XFSPROGS_DIR) ; \
		$(STRIP) $(XFSPROGS_STRIP) $(XFSPROGS_STRIP_LIBDEP) \
	)
	$(STRIP) $(XFSPROGS_DIR)/lib*/lib*.so.*.*
endif
	touch -c $(XFSPROGS_DIR)/$(XFSPROGS_BINARY)

$(TARGET_DIR)/$(XFSPROGS_TARGET_BINARY): $(XFSPROGS_DIR)/$(XFSPROGS_BINARY)
	$(MAKE1) PATH=$(TARGET_PATH) \
	    DIST_ROOT=$(TARGET_DIR) \
	    prefix=/usr \
	    exec-prefix=/ \
	    -C $(XFSPROGS_DIR) install
	rm -rf $(TARGET_DIR)/usr/man $(TARGET_DIR)/usr/share/doc
	touch -c $(TARGET_DIR)/$(XFSPROGS_TARGET_BINARY)

xfsprogs: uclibc e2fsprogs libtool-cross $(TARGET_DIR)/$(XFSPROGS_TARGET_BINARY)

xfsprogs-clean:
	rm -f $(TARGET_DIR)/bin/xfs_* $(TARGET_DIR)/sbin/xfs_* $(TARGET_DIR)/sbin/*.xfs
	rm -f $(TARGET_DIR)/usr/lib/libhandle.so*
	rm -f $(TARGET_DIR)/usr/lib/libdisk.so* $(TARGET_DIR)/usr/lib/libxfs.so*
	-$(MAKE1) -C $(XFSPROGS_DIR) clean

xfsprogs-dirclean:
	rm -rf $(XFSPROGS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_XFSPROGS)),y)
TARGETS+=xfsprogs
endif
