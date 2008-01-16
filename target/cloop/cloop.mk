#############################################################
#
# mkcloop to build to target cloop filesystems
#
#############################################################
CLOOP_VERSION=2.06
CLOOP_DIR=$(BUILD_DIR)/cloop-$(CLOOP_VERSION)
CLOOP_SOURCE=cloop_$(CLOOP_VERSION)-2.tar.gz
CLOOP_SITE=http://debian-knoppix.alioth.debian.org/sources/

CLOOP_TARGET:=$(IMAGE).cloop
### Note: not used yet! ck
### $(DL_DIR)/$(CLOOP_PATCH1):
### $(WGET) -P $(DL_DIR) $(CLOOP_PATCH1_URL)/$(CLOOP_PATCH1)

$(DL_DIR)/$(CLOOP_SOURCE):
	 $(WGET) -P $(DL_DIR) $(CLOOP_SITE)/$(CLOOP_SOURCE)

$(CLOOP_DIR)/.unpacked: $(DL_DIR)/$(CLOOP_SOURCE) ### $(DL_DIR)/$(CLOOP_PATCH1)
	$(ZCAT) $(DL_DIR)/$(CLOOP_SOURCE) | tar -C $(BUILD_DIR) -xvf -
	touch $@
### $(ZCAT) $(DL_DIR)/$(CLOOP_PATCH1) | patch -p1 -d $(CLOOP_DIR)
### toolchain/patch-kernel.sh $(CLOOP_DIR) target/cloop/ cloop\*.patch

$(CLOOP_DIR)/create_compressed_fs: $(CLOOP_DIR)/.unpacked
	$(MAKE) CFLAGS="-Wall -O2 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -DUSE_ERROR_SILENT" -C $(CLOOP_DIR) \
		APPSONLY=yes -j1

cloop: $(CLOOP_DIR)/create_compressed_fs

cloop-source: $(DL_DIR)/$(CLOOP_SOURCE)

cloop-clean:
	-$(MAKE) -C $(CLOOP_DIR) clean

cloop-dirclean:
	rm -rf $(CLOOP_DIR)

#############################################################
#
# Build the cloop.o kernel module for the HOST
#
#############################################################

$(CLOOP_DIR)/cloop.o: $(CLOOP_DIR)/create_compressed_fs
	$(MAKE) CFLAGS="-Wall -O2 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -DUSE_ERROR_SILENT" -C $(CLOOP_DIR) -j1

cloop-module: $(CLOOP_DIR)/cloop.o

#############################################################
#
# Build the cloop root filesystem image
#
# Note: we need additionall host tools:
# required:
# mkisofs 2.01a34-unofficial-iconv from http://users.utu.fi/jahhein/mkisofs/
# optional:
# symlinks: scan/change symbolic links - v1.2 - by Mark Lord
# from ftp://ftp.ibiblio.org/pub/Linux/utils/file/
#
#############################################################

### Note: target/default/device_table.txt is not yet supported! ck
# the quickfix is to use sudo to mount the previous created cramroot
check-tools:
ifneq ($(BR2_HAVE_MANPAGES),y)
	@rm -rf $(TARGET_DIR)/usr/man
	@rm -rf $(TARGET_DIR)/usr/share/man
endif
ifneq ($(BR2_HAVE_INFOPAGES),y)
	@rm -rf $(TARGET_DIR)/usr/info
	@rm -rf $(TARGET_DIR)/usr/share/info
endif
	@rmdir -p --ignore-fail-on-non-empty $(TARGET_DIR)/usr/share
	which mkisofs
	-@find $(TARGET_DIR) -type f -perm +111 | xargs $(STRIPCMD) 2>/dev/null || true
	- which symlinks && symlinks -r $(TARGET_DIR)

$(IMAGE).cramfs: cramfsroot

clooproot: cloop check-tools $(IMAGE).cramfs
	### $(CLOOP_DIR)/create_compressed_fs -q -D target/default/device_table.txt $(TARGET_DIR) $(CLOOP_TARGET)
	## mkisofs -r $(TARGET_DIR) | $(CLOOP_DIR)/create_compressed_fs - 65536 > $(CLOOP_TARGET)
	sudo mkdir -p /mnt/compressed
	sudo mount -o ro,loop -t cramfs $(IMAGE).cramfs /mnt/compressed
	mkisofs -r /mnt/compressed | $(CLOOP_DIR)/create_compressed_fs - 65536 > $(CLOOP_TARGET)
	- symlinks -r /mnt/compressed
	sudo umount /mnt/compressed
	@echo "Mounting a compressed image:"
	@echo " sudo mkdir -p /mnt/compressed"
	@echo " sudo /sbin/insmod cloop"
	@echo " sudo /sbin/losetup /dev/cloop1 $(CLOOP_TARGET)"
	@echo " sudo mount -o ro -t iso9660 /dev/cloop1 /mnt/compressed"

clooproot-source: cloop-source

clooproot-clean:
	-$(MAKE) -C $(CLOOP_DIR) clean

clooproot-dirclean:
	rm -rf $(CLOOP_DIR)

#############################################################
# symlinks -r /mnt/compressed
# dangling: /mnt/compressed/dev/log -> /tmp/log
# other_fs: /mnt/compressed/etc/mtab -> /proc/mounts
# other_fs: /mnt/compressed/var/lib/pcmcia -> /tmp
# other_fs: /mnt/compressed/var/lock -> /tmp
# other_fs: /mnt/compressed/var/log -> /tmp
# other_fs: /mnt/compressed/var/pcmcia -> /tmp
# other_fs: /mnt/compressed/var/run -> /tmp
# other_fs: /mnt/compressed/var/spool -> /tmp
# other_fs: /mnt/compressed/var/tmp -> /tmp
#
# ls -lrsS root_fs_*.*
# 1296 -rw-r--r-- 1 claus users 1325478 Mar 13 16:52 root_fs_powerpc.cloop
# 1448 -rw-r--r-- 1 claus users 1482752 Mar 13 16:52 root_fs_powerpc.cramfs
# 1840 -rw-r--r-- 1 claus users 1883408 Mar 13 13:14 root_fs_powerpc.jffs2
#############################################################
