#############################################################
#
# lockfile-progs
#
#############################################################
LOCKFILE_PROGS_VERSION=0.1.11
LOCKFILE_PROGS_SOURCE:=lockfile-progs_$(LOCKFILE_PROGS_VERSION).tar.gz
LOCKFILE_PROGS_SITE:=$(BR2_DEBIAN_MIRROR)/debian/pool/main/l/lockfile-progs/
LOCKFILE_PROGS_CAT:=$(ZCAT)
LOCKFILE_PROGS_DIR:=$(BUILD_DIR)/sid
LOCKFILE_PROGS_BINARY:=usr/bin/lockfile-create

$(DL_DIR)/$(LOCKFILE_PROGS_SOURCE):
	 $(WGET) -P $(DL_DIR) $(LOCKFILE_PROGS_SITE)/$(LOCKFILE_PROGS_SOURCE)

lockfile-progs-source: $(DL_DIR)/$(LOCKFILE_PROGS_SOURCE)

$(LOCKFILE_PROGS_DIR)/.unpacked: $(DL_DIR)/$(LOCKFILE_PROGS_SOURCE)
	$(LOCKFILE_PROGS_CAT) $(DL_DIR)/$(LOCKFILE_PROGS_SOURCE) | tar -C $(BUILD_DIR) $(TAR_OPTIONS) -
	toolchain/patch-kernel.sh $(LOCKFILE_PROGS_DIR) package/lockfile-progs/ *.patch
	touch $(LOCKFILE_PROGS_DIR)/.unpacked

$(TARGET_DIR)/$(LOCKFILE_PROGS_BINARY): $(LOCKFILE_PROGS_DIR)/.unpacked
	$(MAKE) $(TARGET_CONFIGURE_OPTS) LDFLAGS="$(TARGET_LDFLAGS)" \
		-C $(LOCKFILE_PROGS_DIR)
	cp -a $(LOCKFILE_PROGS_DIR)/bin/lockfile* $(TARGET_DIR)/usr/bin
	$(STRIPCMD) $(STRIP_STRIP_UNNEEDED) $(TARGET_DIR)/$(LOCKFILE_PROGS_BINARY)

lockfile-progs: uclibc liblockfile $(TARGET_DIR)/$(LOCKFILE_PROGS_BINARY)

lockfile-progs-clean:
	-rm -f $(TARGET_DIR)/usr/bin/lockfile-*
	-$(MAKE) -C $(LOCKFILE_PROGS_DIR) clean

lockfile-progs-dirclean:
	rm -rf $(LOCKFILE_PROGS_DIR)

#############################################################
#
# Toplevel Makefile options
#
#############################################################
ifeq ($(strip $(BR2_PACKAGE_LOCKFILE_PROGS)),y)
TARGETS+=lockfile-progs
endif
